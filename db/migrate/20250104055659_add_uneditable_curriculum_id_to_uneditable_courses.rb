class AddUneditableCurriculumIdToUneditableCourses < ActiveRecord::Migration[7.0]
  def change
    add_column :uneditable_courses, :uneditable_curriculum_id, :uuid
  end
end
