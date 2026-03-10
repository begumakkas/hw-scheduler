class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.integer :course_id
      t.integer :exam_flag
      t.date :due_date
      t.integer :optional_flag
      t.integer :priority_rank
      t.integer :user_id
      t.string :status
      t.string :description
      t.time :due_time
      t.integer :weight_perc
      t.string :task_title

      t.timestamps
    end
  end
end
