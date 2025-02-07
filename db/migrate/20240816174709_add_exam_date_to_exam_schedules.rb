class AddExamDateToExamSchedules < ActiveRecord::Migration[7.0]
  def change
    add_column :exam_schedules, :exam_date, :date
  end
end
