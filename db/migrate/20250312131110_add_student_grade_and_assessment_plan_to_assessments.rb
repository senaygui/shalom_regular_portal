class AddStudentGradeAndAssessmentPlanToAssessments < ActiveRecord::Migration[7.0]
  def change
    add_column :assessments, :student_grade, null: false, type: :uuid, foreign_key: true
    add_column :assessments, :assessment_plan, null: false, type: :uuid, foreign_key: true
    add_column :assessments, :result, :decimal
  end
end
