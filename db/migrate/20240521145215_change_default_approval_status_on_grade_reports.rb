class ChangeDefaultApprovalStatusOnGradeReports < ActiveRecord::Migration[7.0]
  def change
    change_column_default :grade_reports, :registrar_approval, "approved"
    change_column_default :grade_reports, :department_approval, "approved"
  end
end
