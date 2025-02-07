class AddAdminUserToAssessment < ActiveRecord::Migration[7.0]
  def change
    add_reference :assessments, :admin_user, null: false, type: :uuid, foreign_key: true
    add_column :assessments, :status, :integer, default: 0
    add_reference :assessments, :course_registration, null: :false, type: :uuid, foreign_key: true
    remove_column :assessments, :student_grade_id
  end
end
