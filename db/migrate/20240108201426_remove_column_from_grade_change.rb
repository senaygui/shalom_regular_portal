class RemoveColumnFromGradeChange < ActiveRecord::Migration[7.0]
  def change
    remove_column :grade_changes, :academic_calendar_id
  end
end
