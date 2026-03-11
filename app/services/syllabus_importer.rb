class SyllabusImporter
  def self.call(user:, parsed_data:, file_name:, file_url:)
    course = Course.create!(
      user: user,
      name: parsed_data["course_name"],
      instructor_name: parsed_data["instructor_name"],
      instructor_email: parsed_data["instructor_email"],
      meeting_days: parsed_data["meeting_days"],
      meeting_time: parsed_data["meeting_time"],
      location: parsed_data["location"],
      color: %w[red blue green purple teal orange].sample
    )

    Syllabi.create!(
      user: user,
      course: course,
      file_name: file_name,
      file_url: file_url,
      raw_extracted_json: parsed_data.to_json
    )

    Array(parsed_data["policies"]).each do |policy|
      Policy.create!(
        course: course,
        policy_type: policy["policy_type"],
        policy_text: policy["policy_text"]
      )
    end

    Array(parsed_data["tasks"]).each do |task|
      Task.create!(
        user: user,
        course: course,
        task_title: task["task_title"],
        description: task["description"],
        due_date: task["due_date"].presence,
        due_time: task["due_time"].presence,
        exam_flag: task["exam_flag"] || 0,
        optional_flag: task["optional_flag"] || 0,
        weight_perc: task["weight_perc"] || nil,
        status: "not_started",
        priority_rank: 3
      )
    end

    course

  end
end
