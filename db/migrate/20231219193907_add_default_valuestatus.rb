class AddDefaultValuestatus < ActiveRecord::Migration[7.0]
  def change
    change_column_default :add_courses, :status, from: 'nil', to: 0
  end
end
