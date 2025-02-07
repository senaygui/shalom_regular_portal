class AddBatchToCourses < ActiveRecord::Migration[7.0]
  def change
    add_column :courses, :batch, :string, default: "2019/2020"
  end
end
