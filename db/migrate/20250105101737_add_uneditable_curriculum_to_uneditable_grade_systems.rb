class AddUneditableCurriculumToUneditableGradeSystems < ActiveRecord::Migration[6.1]
  def change
    add_reference :uneditable_grade_systems, :uneditable_curriculum, type: :uuid, null: false, foreign_key: true
  end
end
