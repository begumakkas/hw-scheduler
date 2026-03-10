class Course < ApplicationRecord
  has_many  :tasks, class_name: "Task", foreign_key: "course_id", dependent: :destroy
  has_many  :policies, class_name: "Policy", foreign_key: "course_id", dependent: :destroy
  has_many  :syllabis, class_name: "Syllabi", foreign_key: "course_id", dependent: :destroy
  belongs_to :user, required: true, class_name: "User", foreign_key: "user_id"
end
