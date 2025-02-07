class AddAdminUserToAssessmentPlans < ActiveRecord::Migration[7.0]
  def change
    add_reference :assessment_plans, :admin_user, null: false, type: :uuid, foreign_key: true
  end
end
