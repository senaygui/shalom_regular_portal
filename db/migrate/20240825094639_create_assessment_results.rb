class CreateAssessmentResults < ActiveRecord::Migration[7.0]
  def change
    create_table :assessment_results do |t|
      t.references :assessment_plan, null: false, foreign_key: true, type: :uuid
      t.references :assessment, null: false, foreign_key: true, type: :uuid
      t.references :student, null: false, foreign_key: true, type: :uuid
      t.decimal :score

      t.timestamps
    end
  end
end
