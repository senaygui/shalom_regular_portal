class AddCredithourtoStudentgrade < ActiveRecord::Migration[7.0]
  def change
    add_column :student_grades, :credit_hour, :string
    add_column :student_grades, :middle_name, :string
  end
end
