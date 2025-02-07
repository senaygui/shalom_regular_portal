class CreateUneditableGradeSystems < ActiveRecord::Migration[6.1]
  def change
    create_table :uneditable_grade_systems, id: :uuid do |t|
      t.uuid :program_id
      t.uuid :curriculum_id
      t.decimal :min_cgpa_value_to_pass
      t.decimal :min_cgpa_value_to_graduate
      t.string :remark
      t.string :created_by
      t.string :updated_by
      t.string :study_level, default: "undergraduate", null: false
      t.string :source_table, null: false, default: "grade_systems"  # Store source table name
      t.timestamps
    end
  end
end
