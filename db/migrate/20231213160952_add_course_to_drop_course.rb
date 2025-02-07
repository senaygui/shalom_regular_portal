class AddCourseToDropCourse < ActiveRecord::Migration[7.0]
  def change
    add_reference :dropcourses, :course, null: false, foreign_key: true, type: :uuid
  end
end
