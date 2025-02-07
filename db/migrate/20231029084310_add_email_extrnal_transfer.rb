class AddEmailExtrnalTransfer < ActiveRecord::Migration[7.0]
  def change
    add_column :external_transfers, :email, :string, index: true

  end
end
