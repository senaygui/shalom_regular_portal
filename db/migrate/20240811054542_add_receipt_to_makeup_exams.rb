class AddReceiptToMakeupExams < ActiveRecord::Migration[7.0]
  def change
    add_column :makeup_exams, :receipt, :string
  end
end
