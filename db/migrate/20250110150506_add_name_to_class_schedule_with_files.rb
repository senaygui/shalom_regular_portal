class AddNameToClassScheduleWithFiles < ActiveRecord::Migration[7.0]
  def change
    add_column :class_schedule_with_files, :name, :string, null: false
  end
end
