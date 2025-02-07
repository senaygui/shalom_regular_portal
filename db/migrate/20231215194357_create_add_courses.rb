class CreateAddCourses < ActiveRecord::Migration[7.0]
  def change
    create_table :add_courses, id: :uuid do |t|
      t.references :student, null: false, foreign_key: true, type: :uuid
      t.references :course, null: false, foreign_key: true, type: :uuid
      t.references :department, null: false, foreign_key: true, type: :uuid
      t.integer :year
      t.integer :semester
      t.integer :status
      t.references :section, null: false, foreign_key: true, type: :uuid
      t.integer :credit_hour
      t.integer :ects

      t.timestamps
    end
  end
end
