class AcademicStatus < ApplicationRecord
  belongs_to :grade_system

  after_create :copy_to_uneditable_academic_status

  private

  def copy_to_uneditable_academic_status
    UneditableAcademicStatus.create!(
      grade_system_id: self.grade_system_id,
      status: self.status,
      min_value: self.min_value,
      max_value: self.max_value,
      created_by: self.created_by,
      updated_by: self.updated_by
    )
  end
end
