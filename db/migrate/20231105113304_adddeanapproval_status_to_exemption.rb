class AdddeanapprovalStatusToExemption < ActiveRecord::Migration[7.0]
  def change
    add_column :exemptions, :dean_approval_status, :integer, deafult: 0
    add_column :exemptions, :registeral_approval_status, :integer, deafult: 0
  end
end
