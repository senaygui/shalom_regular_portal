class Section < ApplicationRecord
  
	belongs_to :program
	has_many :students
	has_many :grade_reports
	has_many :semester_registrations
	has_many :course_registrations
	has_many :grade_changes
	has_many :course_instructors
	has_many :attendances, dependent: :destroy
	has_many :withdrawals
	has_many :recurring_payments
	has_many :add_and_drops
	has_many :makeup_exams
	has_many :class_schedules
	has_many :exam_schedules
	##scope
	scope :by_program, -> (program_id) { where(program_id: program_id) }

    scope :instructor_courses, -> (user_id) {CourseInstructor.where(admin_user_id: user_id).pluck(:section_id)}
    scope :instructors, -> (user_id) {CourseInstructor.where(section_id: instructor_courses(user_id)).pluck(:course_id)}

	##validations
    validates :section_short_name, :presence => true
		validates :section_full_name, :presence => true, uniqueness: true
		validates :year, :presence => true
		validates :semester, :presence => true

  enum section_status: {
	empty: 0,
	partial: 1,
	full: 2
  }


end
