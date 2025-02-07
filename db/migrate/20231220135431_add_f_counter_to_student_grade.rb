class AddFCounterToStudentGrade < ActiveRecord::Migration[7.0]
  def change
    add_column :student_grades, :f_counter, :integer, default: 0
  end
end
