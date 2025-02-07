class UneditableCourse < ApplicationRecord
    belongs_to :curriculum
    belongs_to :uneditable_curriculum
    belongs_to :course_module
  	belongs_to :program, optional: true
end
