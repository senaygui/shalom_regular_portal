class AddDepartmentHeadNameToStudentGrade < ActiveRecord::Migration[7.0]
  def change
    add_column :student_grades, :department_head_name, :string
  end
end
