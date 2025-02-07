class AddDropIdToAddCourse < ActiveRecord::Migration[7.0]
  def change
    add_reference :add_courses, :dropcourse, null: true, foreign_key: true, type: :uuid
  end
end
