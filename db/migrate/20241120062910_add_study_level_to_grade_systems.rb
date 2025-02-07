class AddStudyLevelToGradeSystems < ActiveRecord::Migration[7.0]
  def change
    add_column :grade_systems, :study_level, :string, null: false, default: "undergraduate"
  end
end
