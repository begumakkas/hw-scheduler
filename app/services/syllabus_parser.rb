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
                - For due_date, use YYYY-MM-DD when explicit, otherwise null.
                - For due_time, use HH:MM when explicit, otherwise null.
                - Keep policy_type short, like late_work, attendance, grading, participation.

                Additional extraction rules:
                - The syllabus may describe assignments indirectly rather than as a neat task list.
                - When the syllabus clearly describes a recurring assignment structure, infer task records from that structure.
                - Example: if the syllabus says there are 7 reaction papers and implies they occur weekly, generate 7 reaction paper tasks.
                - If exact dates are not explicitly provided or cannot be derived with confidence, set due_date to null.
                - Do not invent dates, times, or weights.
                - For each task, include:
                  - is_inferred: 1 if created through inference, else 0
                  - source_text: exact supporting text from the syllabus
                  - inference_note: short explanation of the inference, or null if not inferred
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
