class AddFinanceStatusAndProgramIdToExternalTransfers < ActiveRecord::Migration[7.0]
  def change
    add_column :external_transfers, :finance_status, :string, default: "pending"
    add_column :external_transfers, :program_id, :uuid

    # Adding an index on program_id for better query performance
    add_index :external_transfers, :program_id
  end
end
