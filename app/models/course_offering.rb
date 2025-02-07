class CourseOffering < ApplicationRecord
  belongs_to :course
  validates :batch, :year, :semester, presence: true
end
