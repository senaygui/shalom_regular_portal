class RemoveFileAttachmentFromClassScheduleWithFiles < ActiveRecord::Migration[7.0]
  def change
    remove_column :class_schedule_with_files, :file_attachment, :string
  end
end
