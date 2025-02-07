class AddSemesterDeadlinesToPayments < ActiveRecord::Migration[7.0]
  def change
    add_column :payments, :semester_1_deadline, :date
    add_column :payments, :semester_2_deadline, :date
    add_column :payments, :semester_3_deadline, :date
  end
end
