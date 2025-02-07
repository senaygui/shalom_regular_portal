class CreateClassSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :class_schedules do |t|
      t.references :course, null: false, foreign_key: true, type: :uuid, foreign_key: true
      t.references :program, null: false, foreign_key: true, type: :uuid, foreign_key: true
      t.references :section, null: false, foreign_key: true, type: :uuid, foreign_key: true
      t.string :day_of_week
      t.time :start_time
      t.time :end_time
      t.string :classroom
      t.string :class_type
      t.string :instructor_name

      t.timestamps
    end
  end
end
