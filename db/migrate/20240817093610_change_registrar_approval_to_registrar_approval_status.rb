class ChangeRegistrarApprovalToRegistrarApprovalStatus < ActiveRecord::Migration[7.0]
  def change
    remove_column :readmissions, :registrar_approval, :boolean
    
    # Add the new column with default value
    add_column :readmissions, :registrar_approval_status, :string, default: "pending"
    
  end
end
