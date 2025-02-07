class CreateClassScheduleWithFiles < ActiveRecord::Migration[6.1]
  def change
    create_table :class_schedule_with_files do |t|
      t.string :file_attachment, null: false
      t.timestamps
    end
  end
end
