class ChangeIdToUuidInExamScheduleWithFiles < ActiveRecord::Migration[6.0]
  def change
    # Drop the existing table
    drop_table :exam_schedule_with_files, if_exists: true

    # Recreate the table with UUID primary key
    create_table :exam_schedule_with_files, id: :uuid do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end
