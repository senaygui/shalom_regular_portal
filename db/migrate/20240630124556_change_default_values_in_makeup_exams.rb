class ChangeDefaultValuesInMakeupExams < ActiveRecord::Migration[7.0]
  def change
    change_column_default :makeup_exams, :instructor_approval, from: 'pending', to: 'approved'
    change_column_default :makeup_exams, :registrar_approval, from: 'pending', to: 'approved'
    change_column_default :makeup_exams, :dean_approval, from: 'pending', to: 'approved'
    change_column_default :makeup_exams, :academic_affair_approval, from: 'pending', to: 'approved'
  end
end
