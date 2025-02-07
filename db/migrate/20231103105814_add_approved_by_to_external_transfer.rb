class AddApprovedByToExternalTransfer < ActiveRecord::Migration[7.0]
  def change
    add_column :external_transfers, :approved_by, :string
  end
end
