class CreateUneditableCourses < ActiveRecord::Migration[6.1]
  def change
    create_table :uneditable_courses, id: :uuid do |t|
      t.uuid :course_module_id
      t.uuid :curriculum_id
      t.uuid :program_id
      t.string :course_title, null: false
      t.string :course_code, null: false
      t.text :course_description
      t.integer :year, default: 1, null: false
      t.integer :semester, default: 1, null: false
      t.datetime :course_starting_date
      t.datetime :course_ending_date
      t.integer :credit_hour, null: false
      t.integer :lecture_hour, null: false
      t.integer :lab_hour, default: 0
      t.integer :ects, null: false
      t.string :created_by
      t.string :last_updated_by
      t.string :source_table, null: false, default: "courses"  # Store source table name
      t.timestamps
    end
  end
end
