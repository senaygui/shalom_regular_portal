class AssesmentMaagement < ActiveRecord::Migration[7.0]
  def change
    remove_column :assessments, :assessment_plan_id
    remove_column :assessments, :result

    add_column :assessments, :result, :jsonb
  end
end
