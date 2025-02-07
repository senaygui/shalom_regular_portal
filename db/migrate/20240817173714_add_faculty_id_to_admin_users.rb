class AddFacultyIdToAdminUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :admin_users, :faculty_id, :uuid, default: nil, null: true
 end
end
