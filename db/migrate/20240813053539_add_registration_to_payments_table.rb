class AddRegistrationToPaymentsTable < ActiveRecord::Migration[7.0]
  def change
    add_column :payments, :semester_1_registration_date, :date
    add_column :payments, :semester_2_registration_date, :date
    add_column :payments, :semester_3_registration_date, :date
  end
end
