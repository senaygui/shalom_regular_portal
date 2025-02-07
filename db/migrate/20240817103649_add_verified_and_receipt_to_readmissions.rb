class AddVerifiedAndReceiptToReadmissions < ActiveRecord::Migration[7.0]
  def change
    add_column :readmissions, :verified, :boolean
    add_column :readmissions, :receipt, :string
  end
end
