class AddNewProgramIdAndNewDepartmentIdToTransfers < ActiveRecord::Migration[7.0]
  def change
    add_column :transfers, :new_program_id, :uuid
    add_column :transfers, :new_department_id, :uuid
  end
end
