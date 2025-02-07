class AddDropPendingStatusToCourseRegistraegistration < ActiveRecord::Migration[7.0]
  def change
    add_column :course_registrations, :drop_pending_status, :integer, default: 0
  end
end
