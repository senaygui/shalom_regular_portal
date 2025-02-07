class AddDepartmentIdToProgramExemptions < ActiveRecord::Migration[7.0]
  def change
    add_column :program_exemptions, :department_id, :uuid
    add_index :program_exemptions, :department_id
  end
end
