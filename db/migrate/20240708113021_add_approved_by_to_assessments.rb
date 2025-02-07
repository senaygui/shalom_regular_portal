class AddApprovedByToAssessments < ActiveRecord::Migration[7.0]
  def change
    add_column :assessments, :approved_by_instructor_id, :integer
    add_column :assessments, :approved_by_head_id, :integer
  end
end
