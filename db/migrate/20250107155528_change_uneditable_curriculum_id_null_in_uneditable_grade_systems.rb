class ChangeUneditableCurriculumIdNullInUneditableGradeSystems < ActiveRecord::Migration[6.0]
  def change
    change_column_null :uneditable_grade_systems, :uneditable_curriculum_id, true
  end
end
