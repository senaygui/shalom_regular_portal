class AddFileAttachmentAndCommentToClassSchedules < ActiveRecord::Migration[7.0]
  def change
    add_column :class_schedules, :file_attachment, :string
    add_column :class_schedules, :comment, :text
  end
end
