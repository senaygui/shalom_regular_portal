class CourseModule < ApplicationRecord
  #validations
    validates :module_title, :presence => true,:length => { :within => 2..140 }
    validates :module_code, :presence => true,:length => { :within => 2..50 }

  ##associations
  	belongs_to :department
  	has_many :courses, dependent: :destroy
  ##scope
  	scope :recently_added, lambda { where('created_at >= ?', 1.week.ago)}

    after_create :copy_to_uneditable_course_module

  private

  def copy_to_uneditable_course_module
    UneditableCourseModule.create!(
      module_title: self.module_title,
      department_id: self.department_id,
      module_code: self.module_code,
      overview: self.overview,
      description: self.description,
      created_by: self.created_by,
      last_updated_by: self.last_updated_by
    )
  end
end
