class AddYearSemesterToClassSchedules < ActiveRecord::Migration[7.0]
  def change
    add_column :class_schedules, :year, :integer, default: 1, null: false
    add_column :class_schedules, :semester, :integer, default: 1, null: false
  end
end
