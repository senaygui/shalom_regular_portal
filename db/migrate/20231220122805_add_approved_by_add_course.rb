class AddApprovedByAddCourse < ActiveRecord::Migration[7.0]
  def change
    add_column :add_courses, :approved_by, :string
  end
end
