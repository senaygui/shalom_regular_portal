class AddIsActiveToCourseRegistration < ActiveRecord::Migration[7.0]
  def change
    add_column :course_registrations, :is_active, :integer, default: 1
  end
end
