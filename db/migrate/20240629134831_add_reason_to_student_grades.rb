class AddReasonToStudentGrades < ActiveRecord::Migration[7.0]
  def change
    add_column :student_grades, :reason, :string
  end
end
