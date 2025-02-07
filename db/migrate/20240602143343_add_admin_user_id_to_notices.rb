class AddAdminUserIdToNotices < ActiveRecord::Migration[7.0]
  def change
    add_column :notices, :admin_user_id, :integer
  end
end
