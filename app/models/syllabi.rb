# == Schema Information
#
# Table name: syllabis
#
#  id                 :bigint           not null, primary key
#  file_name          :string
#  file_url           :string
#  raw_extracted_json :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  course_id          :integer
#  user_id            :integer
#
class Syllabi < ApplicationRecord
  belongs_to :course, required: true, class_name: "Course", foreign_key: "course_id"
  belongs_to :user, required: true, class_name: "User", foreign_key: "user_id"
end
