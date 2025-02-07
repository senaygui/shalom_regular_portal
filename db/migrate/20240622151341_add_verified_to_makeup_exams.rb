class AddVerifiedToMakeupExams < ActiveRecord::Migration[7.0]
  def change
    add_column :makeup_exams, :verified, :boolean
  end
end
