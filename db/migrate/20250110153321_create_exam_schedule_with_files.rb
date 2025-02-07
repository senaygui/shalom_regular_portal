class CreateExamScheduleWithFiles < ActiveRecord::Migration[7.0]
  def change
    create_table :exam_schedule_with_files do |t|
      t.string :name

      t.timestamps
    end
  end
end
