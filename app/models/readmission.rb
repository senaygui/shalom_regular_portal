class Readmission < ApplicationRecord
  has_one_attached :receipt


  belongs_to :program
  belongs_to :department
  belongs_to :student
  belongs_to :section
  belongs_to :academic_calendar

  has_one :other_payment, as: :payable, dependent: :destroy

  private

  def activate_student_if_approved_and_verified
    if (registrar_approval_status == 'approved' && finance_approval_status == 'approved')
      student.update(account_status: 'active')
    end
  end

  after_save :activate_student_if_approved_and_verified
end
