class AddCourseExemptionProcessedToTransfers < ActiveRecord::Migration[7.0]
  def change
    add_column :transfers, :course_exemption_processed, :boolean, default: false
  end
end
