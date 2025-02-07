class AddstudyToExtrnalTransfer < ActiveRecord::Migration[7.0]
  def change
    add_column :external_transfers, :study_level, :string
    add_column :external_transfers, :admission_type, :string
  end
end
