class AddmessageExtrnalTransfer < ActiveRecord::Migration[7.0]
  def change
    add_column :external_transfers, :message, :string

  end
end
