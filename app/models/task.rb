class Task < ApplicationRecord
  belongs_to :course, required: true, class_name: "Course", foreign_key: "course_id"
  belongs_to :user, required: true, class_name: "User", foreign_key: "user_id"
end
