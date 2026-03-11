class ChangeMeetingDaysInCourses < ActiveRecord::Migration[8.0]
  def change
    change_column :courses, :meeting_days, :string
  end
end
