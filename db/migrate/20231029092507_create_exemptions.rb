class CreateExemptions < ActiveRecord::Migration[7.0]
  def change
    create_table :exemptions, id: :uuid do |t|
      t.string :course_title
      t.string :letter_grade
      t.string :course_code
      t.integer :credit_hour
      t.string :department_approval, default: "pending"
      t.string :dean_approval, default: "pending"
      t.string :registeral_approval, default: "pending"
      t.boolean :exemption_needed, default: false
      t.references :external_transfer, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
