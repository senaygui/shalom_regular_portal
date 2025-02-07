class RenameVerifiedToFinanceApprovalStatusInReadmissions < ActiveRecord::Migration[7.0]
  def change
    rename_column :readmissions, :verified, :finance_approval_status
    change_column :readmissions, :finance_approval_status, :string, default: 'pending'
  end
end
