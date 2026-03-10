class CreateSyllabis < ActiveRecord::Migration[8.0]
  def change
    create_table :syllabis do |t|
      t.integer :user_id
      t.integer :course_id
      t.string :file_name
      t.string :raw_extracted_json
      t.string :file_url

      t.timestamps
    end
  end
end
