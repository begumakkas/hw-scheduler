class CreateCourses < ActiveRecord::Migration[8.0]
  def change
    create_table :courses do |t|
      t.string :name
      t.integer :user_id
      t.string :location
      t.time :meeting_time
      t.string :instructor_name
      t.string :instructor_email
      t.string :color
      t.date :meeting_days

      t.timestamps
    end
  end
end
