class Transfer < ApplicationRecord
	##validations
		validates :semester, presence: true
		validates :year, presence: true
	##assocations
	  belongs_to :student
	  belongs_to :program
	  belongs_to :section
	  belongs_to :department
	  belongs_to :academic_calendar
	  has_many :course_exemptions, as: :exemptible, dependent: :destroy
	  accepts_nested_attributes_for :course_exemptions, reject_if: :all_blank, allow_destroy: true

	  after_save :update_student_department_and_program, if: :registrar_approval_changed_to_approved?

  private

  def registrar_approval_changed_to_approved?
    saved_change_to_registrar_approval? && registrar_approval == 'approved'
  end

  def update_student_department_and_program
    student.update!(
      department_id: new_department_id,
      program_id: new_program_id
    )
  end

end
