class AssessmentResult < ApplicationRecord
  belongs_to :assessment_plan
  belongs_to :assessment
  belongs_to :student

  validates :score, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
