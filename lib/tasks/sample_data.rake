desc "Fill the database tables with some sample data"
task sample_data: :environment do
  require "faker"
  require "json"
  require "securerandom"

  if Rails.env.development?
    puts "Clearing old sample data..."

    Task.delete_all
    Policy.delete_all
    Syllabi.delete_all
    Course.delete_all
    User.delete_all

    puts "Creating users, courses, syllabi, policies, and tasks..."

    5.times do
      password = "password123"

      user = User.create!(
        email: Faker::Internet.unique.email,
        password: password,
        password_confirmation: password
      )

      rand(3..5).times do
        course_name = [
          "Introduction to Economics",
          "Data Structures",
          "Urban Studies Seminar",
          "Machine Learning for Policy",
          "Modern Political Theory",
          "Database Systems",
          "Intro to Statistics",
          "Environmental Policy",
          "Discrete Mathematics",
          "Software Engineering"
        ].sample

        meeting_days = [
          Date.today.beginning_of_week + 1,
          Date.today.beginning_of_week + 2,
          Date.today.beginning_of_week + 3,
          Date.today.beginning_of_week + 4,
          Date.today.beginning_of_week + 5
        ].sample

        meeting_time = Time.zone.parse("#{rand(8..16)}:00")

        course = Course.create!(
          user: user,
          name: course_name,
          location: "#{Faker::University.name.split.first} Hall #{rand(100..499)}",
          instructor_name: Faker::Name.name,
          instructor_email: Faker::Internet.email,
          color: %w[red blue green yellow purple orange teal].sample,
          meeting_days: meeting_days,
          meeting_time: meeting_time
        )

        raw_json = {
          course_name: course.name,
          instructor: {
            name: course.instructor_name,
            email: course.instructor_email
          },
          policies: [
            {
              policy_type: "late_work",
              policy_text: "Late work loses 10% per day unless prior approval is granted."
            },
            {
              policy_type: "attendance",
              policy_text: "More than 2 unexcused absences may affect final grade."
            }
          ],
          tasks: [
            {
              task_title: "Midterm Exam",
              due_date: (Date.today + 30).to_s,
              due_time: "10:00",
              exam_flag: 1,
              optional_flag: 0,
              priority_rank: 1,
              status: "not_started",
              weight_perc: 25
            },
            {
              task_title: "Final Paper",
              due_date: (Date.today + 60).to_s,
              due_time: "23:59",
              exam_flag: 0,
              optional_flag: 0,
              priority_rank: 2,
              status: "not_started",
              weight_perc: 30
            }
          ]
        }

        Syllabi.create!(
          user: user,
          course: course,
          file_name: "#{course.name.parameterize(separator: "_")}_syllabus.pdf",
          file_url: "https://example.com/uploads/#{SecureRandom.hex(8)}.pdf",
          raw_extracted_json: raw_json.to_json
        )

        [
          {
            policy_type: "late_work",
            policy_text: "Late assignments are penalized by 10% for each day late."
          },
          {
            policy_type: "attendance",
            policy_text: "Students are expected to attend every class session."
          },
          {
            policy_type: "participation",
            policy_text: "Class participation contributes to the final course grade."
          }
        ].sample(2).each do |policy_attrs|
          Policy.create!(
            course: course,
            policy_type: policy_attrs[:policy_type],
            policy_text: policy_attrs[:policy_text]
          )
        end

        rand(6..10).times do |i|
          due_date = Date.today + rand(3..90)
          due_time = ["09:00", "11:59", "17:00", "23:59"].sample

          task_type = [:exam, :assignment, :project, :reading, :quiz].sample
          exam_flag = task_type == :exam ? 1 : 0
          optional_flag = [0, 0, 0, 1].sample

          task_title =
            case task_type
            when :exam
              ["Midterm 1", "Midterm 2", "Final Exam", "Quiz 1", "Quiz 2"].sample
            when :assignment
              "Homework #{i + 1}"
            when :project
              ["Group Project Proposal", "Final Project", "Project Milestone"].sample
            when :reading
              ["Weekly Reading", "Reading Response", "Discussion Post"].sample
            when :quiz
              ["Quiz #{i + 1}", "Short Quiz", "Pop Quiz"].sample
            end

          Task.create!(
            user: user,
            course: course,
            task_title: task_title,
            description: Faker::Lorem.sentence(word_count: 10),
            due_date: due_date,
            due_time: Time.zone.parse(due_time),
            exam_flag: exam_flag,
            optional_flag: optional_flag,
            priority_rank: rand(1..5),
            status: %w[not_started in_progress completed].sample,
            weight_perc: [5, 10, 15, 20, 25, 30].sample
          )
        end
      end
    end

    puts "Done."
    puts "Created:"
    puts "- #{User.count} users"
    puts "- #{Course.count} courses"
    puts "- #{Syllabi.count} syllabi"
    puts "- #{Policy.count} policies"
    puts "- #{Task.count} tasks"
  else
    puts "Sample data task only runs in development."
  end
end
