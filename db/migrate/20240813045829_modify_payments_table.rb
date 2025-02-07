class ModifyPaymentsTable < ActiveRecord::Migration[7.0]
  def change
    remove_column :payments, :semester, :integer
    add_column :payments, :registration_date, :date
  end
end
