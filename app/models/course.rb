class Course < ApplicationRecord
	before_save :attribute_assignment
	scope :by_program, -> (program_id) { where(program_id: program_id) }
	after_save :create_or_update_course_offering
	after_create :copy_to_uneditable_course
	#validations
        validates :semester, :presence => true
		validates :year, :presence => true
		validates :credit_hour, :presence => true
		validates :lecture_hour, :presence => true
		validates :ects, :presence => true
		validates :course_code, :presence => true
		# validates :student_grades, presence: true
  ##associations
  	belongs_to :course_module
  	belongs_to :curriculum
  	belongs_to :program, optional: true

	
 		# has_many :programs, through: :curriculums, dependent: :destroy
	has_many :course_offerings, dependent: :destroy 
 	has_many :student_grades, dependent: :destroy
 	has_many :student_courses, dependent: :destroy
 	has_many :assessments
	  has_many :course_registrations, dependent: :destroy
	  has_many :invoice_items
	  # has_many :course_sections, dependent: :destroy
	  has_many :attendances, dependent: :destroy
	  has_one_attached :course_outline, dependent: :destroy
	  #has_many :assessment_plans, dependent: :destroy
	  #accepts_nested_attributes_for :assessment_plans, reject_if: :all_blank, allow_destroy: true
	  
	  has_many :assessment_plans, dependent: :destroy
  	  accepts_nested_attributes_for :assessment_plans, allow_destroy: true
	  has_many :course_instructors
	  accepts_nested_attributes_for :course_instructors, reject_if: :all_blank, allow_destroy: true

		has_many :sessions
		has_many :class_schedules
		has_many :exam_schedules
		has_many :grade_changes
		has_many :makeup_exams
		has_many :add_and_drop_courses
		has_many :course_prerequisites, class_name: "Prerequisite"
  	has_many :prerequisites, through: :course_prerequisites, source: :prerequisite
  	accepts_nested_attributes_for :course_prerequisites, reject_if: :all_blank, allow_destroy: true
	  has_many :exemptions 
  	has_many :course_exemptions
  ##scope
  	scope :recently_added, lambda { where('created_at >= ?', 1.week.ago)}
  	scope :instructor_courses, -> (user_id) {CourseInstructor.where(admin_user_id: user_id).pluck(:course_id)}
	scope :for_student, -> (student) {
		where(program_id: student.program_id, year: student.year, semester: student.semester)
	  }
	

	  
  private

  def copy_to_uneditable_course
    UneditableCourse.create(
      course_module_id: self.course_module_id,
      curriculum_id: self.curriculum_id,
      program_id: self.program_id,
      course_title: self.course_title,
      course_code: self.course_code,
      course_description: self.course_description,
      year: self.year,
      semester: self.semester,
      course_starting_date: self.course_starting_date,
      course_ending_date: self.course_ending_date,
      credit_hour: self.credit_hour,
      lecture_hour: self.lecture_hour,
      lab_hour: self.lab_hour,
      ects: self.ects,
      created_by: self.created_by,
      last_updated_by: self.last_updated_by
    )
  end

  def attribute_assignment
    self[:program_id] = self.curriculum.program.id
  end

  def create_or_update_course_offering
    course_offering = CourseOffering.find_or_initialize_by(course_id: self.id, batch: self.batch)
    
    course_offering.update(
      year: self.year,
      semester: self.semester,
      course_starting_date: self.course_starting_date,
      course_ending_date: self.course_ending_date,
      credit_hour: self.credit_hour,
      lecture_hour: self.lecture_hour,
      lab_hour: self.lab_hour,
      ects: self.ects,
      major: self.major,
      created_by: self.created_by,
      last_updated_by: self.last_updated_by
    )
  end
end
