# app/services/syllabus_parser.rb
require "json"
require "pathname"

class SyllabusParser
  def self.call(file_path:)
    client = OpenAI::Client.new(api_key: ENV.fetch("OPENAI_API_KEY"))

    uploaded_file = client.files.create(
      file: Pathname(file_path.to_s),
      purpose: "user_data"
    )

    response = client.responses.create(
      model: "gpt-4o-mini",
      input: [
        {
          role: "user",
          content: [
            {
              type: "input_text",
              text: <<~PROMPT
                Extract this syllabus PDF into structured JSON.
                
                Return exactly this shape:
                {
                  "course_name": string or null,
                  "instructor_name": string or null,
                  "instructor_email": string or null,
                  "meeting_days": string or null,
                  "meeting_time": string or null,
                  "location": string or null,
                  "policies": [
                    {
                      "policy_type": string,
                      "policy_text": string
                    }
                  ],
                  "tasks": [
                    {
                      "task_title": string,
                      "description": string or null,
                      "due_date": string or null,
                      "due_time": string or null,
                      "exam_flag": integer,
                      "optional_flag": integer,
                      "weight_perc": integer or null
                    }
                  ]
                }

                Rules:
                - Return only valid JSON.
                - Do not include markdown fences.
                - If a field is missing, use null.
                - Use 1 for true and 0 for false for exam_flag and optional_flag.
                - Set exam_flag to 1 only for actual exams, tests, quizzes, or in-class exams.
                - Essays, papers, reaction papers, and written assignments should have exam_flag = 0.
                - For due_date, use YYYY-MM-DD when explicit, otherwise null.
                - For due_time, use HH:MM when explicit, otherwise null.
                - Keep policy_type short, like late_work, attendance, grading, participation.
                - The syllabus may describe assignments indirectly rather than as a neat task list.
                
                - If exact dates are not explicitly provided or cannot be derived with confidence, set due_date to null.
                - Do not invent dates, times, or weights.
                - For each task, include:
                  - is_inferred: 1 if created through inference, else 0
                  - source_text: exact supporting text from the syllabus
                  - inference_note: short explanation of the inference, or null if not inferred

                Task generation rules for recurring assignments:
                  - If the syllabus explicitly states the number of assignments in a recurring series, generate exactly that many task records.
                  - Do not collapse a recurring assignment series into a smaller number of representative tasks.
                  - Example: if the syllabus says there are 7 reaction papers, the output must contain 7 distinct reaction paper tasks.
                  - If the syllabus indicates that the assignment is weekly or recurring, create one task per occurrence until the explicitly stated total count is reached.
                  - If exact dates are not provided, still generate all required task records and set due_date to null.
                  - Use sequential titles for recurring assignments, such as "Reaction Paper 1", "Reaction Paper 2", ..., "Reaction Paper 7".
                  - When the exact count is explicitly stated in the syllabus, the number of generated task records must match that count exactly.
                  - Only generate fewer than the stated count if the syllabus explicitly says some assignments are dropped, optional, or excluded from submission.
                  - If the syllabus includes a reading list organized by class session, week, or date, create a distinct task for each assigned reading.
                  - Use a short readable task title, such as the author name, article title, or chapter title, rather than the full citation.
                  - Do not combine multiple assigned readings into a single task unless the syllabus clearly presents them as one combined reading assignment.
                  - The tasks array must include both graded assignments and assigned readings.
                  - If the syllabus includes readings assigned to a specific class date, class session, week, or topic, create a distinct reading task for each assigned reading.
                  - Treat weekly or class-session readings as actionable tasks, even if they appear only in the course schedule table.

                  Some syllabi will include a list of readings with sources, for these:
                    - If multiple readings are listed under one class session, create a separate task for each reading unless the syllabus clearly presents them as one combined reading assignment.
                    - For readings assigned to a class date, use that class date as the due_date when it can be determined from the syllabus.
                    - For reading tasks, set exam_flag = 0.
                    - For optional readings, set optional_flag = 1. Otherwise set optional_flag = 0.
                    - Use a short readable task title, such as the author name, short article title, or chapter title, rather than the full citation.
                    - Do not ignore readings just because they are embedded in a schedule table instead of listed under assignments.

                  - populate "meeting_days" with the days of the week that the class meets. For example, syllabus might say "T/Th", which means the class meets on Tuesdays and Thursdays.
                  - populate "meeting_time" with class start and end times. For example "12:30pm to 1:50pm"

                  Validation rules:
                  - Before returning the JSON, verify that the number of generated tasks matches any explicit counts stated in the syllabus.
                  - If the syllabus states "7 reaction papers", the output must include 7 reaction paper tasks.
                  - If the count in the output does not match the explicit syllabus count, revise the output before returning it.
                
              PROMPT
            },
            {
              type: "input_file",
              file_id: uploaded_file.id
            }
          ]
        }
      ]
    )

    JSON.parse(response.output_text)
  end
end
