class UneditableAcademicStatus < ApplicationRecord
    belongs_to :grade_system, optional: true
  end
  