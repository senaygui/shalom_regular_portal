class AddCourseIdToExemptions < ActiveRecord::Migration[7.0]
  def change
    add_column :exemptions, :course_id, :uuid, null: true
    add_index :exemptions, :course_id
  end
end
