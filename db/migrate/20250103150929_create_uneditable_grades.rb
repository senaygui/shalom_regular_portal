class CreateUneditableGrades < ActiveRecord::Migration[6.1]
  def change
    create_table :uneditable_grades, id: :uuid do |t|
      t.uuid :grade_system_id
      t.string :letter_grade, null: false
      t.decimal :grade_point, null: false
      t.integer :min_row_mark, null: false
      t.integer :max_row_mark, null: false
      t.string :updated_by
      t.string :created_by
      t.string :source_table, null: false, default: "grades"  # Store source table name
      t.timestamps
    end
  end
end
