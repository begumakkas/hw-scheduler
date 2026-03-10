# == Schema Information
#
# Table name: courses
#
#  id               :bigint           not null, primary key
#  color            :string
#  instructor_email :string
#  instructor_name  :string
#  location         :string
#  meeting_days     :date
#  meeting_time     :time
#  name             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :integer
#
class Course < ApplicationRecord
  has_many  :tasks, class_name: "Task", foreign_key: "course_id", dependent: :destroy
  has_many  :policies, class_name: "Policy", foreign_key: "course_id", dependent: :destroy
  has_many  :syllabis, class_name: "Syllabi", foreign_key: "course_id", dependent: :destroy
  belongs_to :user, required: true, class_name: "User", foreign_key: "user_id"
end
