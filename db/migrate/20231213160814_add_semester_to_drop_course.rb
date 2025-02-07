class AddSemesterToDropCourse < ActiveRecord::Migration[7.0]
  def change
    add_column :dropcourses, :semester, :integer
    add_column :dropcourses, :year, :integer
    # remove_column :dropcourses, :course_registration_id
    # remove_column :course_registrations, :drop_pending_status
  end
end
