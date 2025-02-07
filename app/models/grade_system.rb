class GradeSystem < ApplicationRecord

	##validations
  	validates :min_cgpa_value_to_pass , :presence => true
  	validates :min_cgpa_value_to_graduate , :presence => true
  ##associations
	  belongs_to :program
	  belongs_to :curriculum
	  has_many :grades, dependent: :destroy
	  has_many :academic_statuses, dependent: :destroy
	  accepts_nested_attributes_for :grades, reject_if: :all_blank, allow_destroy: true
	  accepts_nested_attributes_for :academic_statuses, reject_if: :all_blank, allow_destroy: true

	  after_create :copy_to_uneditable_grade_system

	  private

	  def copy_to_uneditable_grade_system
		UneditableGradeSystem.create(
		  #uneditable_curriculum_id: self.uneditable_curriculum_id,
		  program_id: self.program_id,
		  curriculum_id: self.curriculum_id,
		  min_cgpa_value_to_pass: self.min_cgpa_value_to_pass,
		  min_cgpa_value_to_graduate: self.min_cgpa_value_to_graduate,
		  remark: self.remark,
		  created_by: self.created_by,
		  updated_by: self.updated_by,
		  study_level: self.study_level
		)
	  end
end
