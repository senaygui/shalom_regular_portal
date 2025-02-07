class CreateDropcourses < ActiveRecord::Migration[7.0]
  def change
    create_table :dropcourses, id: :uuid do |t|
      t.references :student, null: false, foreign_key: true, type: :uuid
      t.references :course_registration, null: false, foreign_key: true, type: :uuid
      t.integer :status, default: 0, null: false
      t.references :department, null: false, foreign_key: true,type: :uuid
      t.string :approved_by

      t.timestamps
    end
  end
end
