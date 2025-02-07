class SchoolOrUniversityInformation < ApplicationRecord
  ##associations
  	belongs_to :student

  ##validations
  # 	validates :college_or_university, :presence => true, if: :apply_graduate?
		# validates :phone_number, :presence => true, if: :apply_graduate?
		# validates :address, :presence => true, if: :apply_graduate?
		# validates :field_of_specialization, :presence => true, if: :apply_graduate?
  # 	validates :cgpa, :presence => true, if: :apply_graduate?
		# def apply_graduate?
		# 	if self.student.present?
  #   		self.student.study_level == "graduate" 
  #   	end
  # 	end
end