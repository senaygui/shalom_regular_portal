class UneditableCurriculum < ApplicationRecord
    belongs_to :program, optional: true
    has_many :courses, dependent: :destroy
    has_one :grade_system, dependent: :destroy

    has_many :uneditable_courses, dependent: :destroy
    has_one :uneditable_grade_system, foreign_key: :uneditable_curriculum_id, dependent: :destroy
       
    accepts_nested_attributes_for :courses, reject_if: :all_blank, allow_destroy: true
end
