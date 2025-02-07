class CreateCourseOfferings < ActiveRecord::Migration[7.0]
  def change
    create_table :course_offerings do |t|
      t.references :course, null: false, type: :uuid, foreign_key: true
      t.string :batch
      t.integer :year
      t.integer :semester
      t.datetime :course_starting_date
      t.datetime :course_ending_date
      t.integer :credit_hour
      t.integer :lecture_hour
      t.integer :lab_hour
      t.integer :ects
      t.boolean :major
      t.string :created_by
      t.string :last_updated_by

      t.timestamps
    end
  end
end
