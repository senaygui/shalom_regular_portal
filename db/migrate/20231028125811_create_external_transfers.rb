class CreateExternalTransfers < ActiveRecord::Migration[7.0]
  def change
    create_table :external_transfers, id: :uuid do |t|
      t.string :first_name
      t.string :last_name
      t.references :department, null: false, foreign_key: true, type: :uuid
      t.string :previous_institution
      t.string :previous_student_id
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
