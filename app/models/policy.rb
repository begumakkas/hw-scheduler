class Policy < ApplicationRecord
  belongs_to :course, required: true, class_name: "Course", foreign_key: "course_id"
end
