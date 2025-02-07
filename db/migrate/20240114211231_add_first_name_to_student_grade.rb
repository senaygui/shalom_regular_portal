class AddFirstNameToStudentGrade < ActiveRecord::Migration[7.0]
  def change
    add_column :student_grades, :first_name, :string
    add_column :student_grades, :last_name, :string
   
  end
end
