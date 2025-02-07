class AddDetailsToAdminUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :admin_users, :position, :string
    add_column :admin_users, :educational_level, :string
    add_column :admin_users, :employee_type, :string, default: "part_time"
  end
end
