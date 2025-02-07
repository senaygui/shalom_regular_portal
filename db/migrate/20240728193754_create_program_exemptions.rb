class CreateProgramExemptions < ActiveRecord::Migration[7.0]
  def change
    create_table :program_exemptions do |t|
      t.string :course_title
      t.string :letter_grade
      t.string :course_code
      t.integer :credit_hour
      t.string :department_approval
      t.string :dean_approval
      t.string :registrar_approval
      t.boolean :exemption_needed
      t.references :student, type: :uuid, foreign_key: true

      t.timestamps
    end
  end
end
