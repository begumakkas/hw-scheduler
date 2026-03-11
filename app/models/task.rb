# == Schema Information
#
# Table name: tasks
#
#  id            :bigint           not null, primary key
#  description   :string
#  due_date      :date
#  due_time      :time
#  exam_flag     :integer
#  optional_flag :integer
#  priority_rank :integer
#  status        :string
#  task_title    :string
#  weight_perc   :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  course_id     :integer
#  user_id       :integer
#
class Task < ApplicationRecord
  belongs_to :course, optional: true, class_name: "Course", foreign_key: "course_id"
  belongs_to :user, required: true, class_name: "User", foreign_key: "user_id"
end
