class GradeChange < ApplicationRecord

	after_save :current_grade

	##validations
		#validates :semester, :presence => true 
		#validates :previous_result_total, :presence => true 
		#validates :previous_letter_grade, :presence => true 
		#validates :reason, :presence => true 
	##associations
	  belongs_to :course
	  belongs_to :program
	  belongs_to :department
	  belongs_to :section
	  belongs_to :academic_calendar, optional: true
	  # belongs_to :course_section, optional: true
	  belongs_to :student
	  belongs_to :course_registration
	  belongs_to :student_grade
	  belongs_to :assessment, optional: true 
	  belongs_to :student_grade

	  validates :reason, presence: true
	  validates :course_id, presence: true
	  validates :program_id, presence: true
	  validates :department_id, presence: true
	  validates :semester, presence: true
	  validates :year, presence: true
	  validates :previous_result_total, presence: true
	  validates :previous_letter_grade, presence: true

		private

			def current_grade
				if (self.department_approval == "approved") && (self.registrar_approval == "approved") && (self.dean_approval == "approved") && (self.instructor_approval == "approved") && (self.academic_affair_approval== "approved")
	  			self.assessment.update(result: self.add_mark) if self.assessment.present?
	  			self.student_grade.update(assesment_total: self.student_grade.assessments.sum(:result))
	  			self.update_columns(current_result_total: self.student_grade.assesment_total)
	  			self.update_columns(current_letter_grade: self.student_grade.letter_grade)
	  		end
			end
end
