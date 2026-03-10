class CreatePolicies < ActiveRecord::Migration[8.0]
  def change
    create_table :policies do |t|
      t.integer :course_id
      t.string :policy_text
      t.string :policy_type

      t.timestamps
    end
  end
end
