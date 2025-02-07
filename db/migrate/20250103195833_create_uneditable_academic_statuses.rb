class CreateUneditableAcademicStatuses < ActiveRecord::Migration[6.1]
  def change
    create_table :uneditable_academic_statuses, id: :uuid do |t|
      t.uuid :grade_system_id
      t.string :status
      t.decimal :min_value
      t.decimal :max_value
      t.string :created_by
      t.string :updated_by
      t.timestamps
    end
  end
end
