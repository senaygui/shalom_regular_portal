class AddSemesterToPayments < ActiveRecord::Migration[7.0]
  def change
    add_column :payments, :semester, :integer
  end
end
