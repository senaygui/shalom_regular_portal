class CreateUneditableCurriculums < ActiveRecord::Migration[6.1]
  def change
    create_table :uneditable_curriculums, id: :uuid do |t|
      t.uuid :program_id
      t.string :curriculum_title, null: false
      t.string :curriculum_version, null: false
      t.integer :total_course
      t.integer :total_ects
      t.integer :total_credit_hour
      t.string :active_status, default: "active"
      t.datetime :curriculum_active_date, null: false
      t.datetime :depreciation_date
      t.string :created_by
      t.string :last_updated_by
      t.string :source_table, null: false, default: "curriculums"  # Store source table name
      t.timestamps
    end
  end
end
