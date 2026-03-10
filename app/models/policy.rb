# == Schema Information
#
# Table name: policies
#
#  id          :bigint           not null, primary key
#  policy_text :string
#  policy_type :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  course_id   :integer
#
class Policy < ApplicationRecord
  belongs_to :course, required: true, class_name: "Course", foreign_key: "course_id"
end
