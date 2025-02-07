class UneditableGradeSystem < ApplicationRecord
    belongs_to :program
	belongs_to :curriculum
	has_many :grades, dependent: :destroy
	belongs_to :uneditable_curriculum
end
