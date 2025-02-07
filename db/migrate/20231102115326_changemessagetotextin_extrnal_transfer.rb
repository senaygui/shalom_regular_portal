class ChangemessagetotextinExtrnalTransfer < ActiveRecord::Migration[7.0]
  def change
    change_column :external_transfers, :message, :text
  end
end
