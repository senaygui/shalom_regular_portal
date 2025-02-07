class Grade < ApplicationRecord
	##validations
  	validates :letter_grade , :presence => true
  	validates :grade_point , :presence => true
  	validates :min_row_mark , :presence => true
  	validates :max_row_mark , :presence => true
	belongs_to :grade_system

	after_create :copy_to_uneditable_grade

  	private

	  def copy_to_uneditable_grade
		UneditableGrade.create(
		  grade_system_id: self.grade_system_id,
		  letter_grade: self.letter_grade,
		  grade_point: self.grade_point,
		  min_row_mark: self.min_row_mark,
		  max_row_mark: self.max_row_mark,
		  updated_by: self.updated_by,
		  created_by: self.created_by
		)
	  end

end
