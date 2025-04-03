class AddStudentGradeAndAssessmentPlanToAssessments < ActiveRecord::Migration[7.0]
  def change
    # Step 1: Add columns without NOT NULL constraint first
    add_reference :assessments, :student_grade, type: :uuid, foreign_key: true
    add_reference :assessments, :assessment_plan, type: :uuid, foreign_key: true
    remove_column :assessments, :result
    add_column :assessments, :result, :decimal
  end
end
