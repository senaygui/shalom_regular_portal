class AddOutOfBatchToSemesterRegistration < ActiveRecord::Migration[7.0]
  def change
    add_column :semester_registrations, :out_of_batch, :boolean, default: false
  end
end
