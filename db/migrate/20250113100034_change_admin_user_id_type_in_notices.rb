class ChangeAdminUserIdTypeInNotices < ActiveRecord::Migration[6.1]
  def up
    # Temporarily rename the existing column
    rename_column :notices, :admin_user_id, :admin_user_id_old

    # Add a new column with the correct type
    add_column :notices, :admin_user_id, :uuid

    # Migrate the data from the old column to the new column
    Notice.reset_column_information
    Notice.find_each do |notice|
      notice.update_column(:admin_user_id, notice.admin_user_id_old)
    end

    # Remove the old column
    remove_column :notices, :admin_user_id_old
  end

  def down
    # Revert the changes in case of a rollback
    add_column :notices, :admin_user_id_old, :integer
    Notice.reset_column_information
    Notice.find_each do |notice|
      notice.update_column(:admin_user_id_old, notice.admin_user_id)
    end

    remove_column :notices, :admin_user_id
    rename_column :notices, :admin_user_id_old, :admin_user_id
  end
end
