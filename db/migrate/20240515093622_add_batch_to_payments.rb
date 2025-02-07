class AddBatchToPayments < ActiveRecord::Migration[7.0]
  def change
    add_column :payments, :batch, :string
  end
end
