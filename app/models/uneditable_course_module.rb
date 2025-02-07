class UneditableCourseModule < ApplicationRecord
    belongs_to :department, optional: true
  end
  