class DeleteCourseRegistrationfromDropCourses < ActiveRecord::Migration[7.0]
  def change
    remove_column :dropcourses, :course_registration_id
  end
end
