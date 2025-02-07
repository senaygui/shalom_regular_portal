class CreateReadmissions < ActiveRecord::Migration[7.0]
  def change
    create_table :readmissions, id: :uuid do |t|
      t.decimal :last_earned_cgpa, precision: 4, scale: 2
      t.integer :readmission_semester
      t.integer :readmission_year
      t.text :reason_for_withdrawal
      t.boolean :registrar_approval
      t.text :comments

      t.references :program, type: :uuid, foreign_key: true
      t.references :department, type: :uuid, foreign_key: true
      t.references :student, type: :uuid, foreign_key: true
      t.references :section, type: :uuid, foreign_key: true
      t.references :academic_calendar, type: :uuid, foreign_key: true

      t.timestamps
    end  
  end
end
