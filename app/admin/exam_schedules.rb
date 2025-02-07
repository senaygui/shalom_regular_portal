ActiveAdmin.register ExamSchedule do
  permit_params :course_id, :program_id, :section_id, :exam_date, :start_time, :end_time, :exam_type, :classroom

  index do
    selectable_column
    id_column
    column :course
    column :program
    column :section
    column :exam_date
    column :start_time
    column :end_time
    column :exam_type
    column :classroom
    actions
  end

  form do |f|
    # Fetch options for Programs
   # programs = Program.all.map { |p| [p.program_name, p.id] }
   # 
   # # Handle nil cases
   # selected_program_id = params.dig(:exam_schedule, :program_id)
   # selected_course_id = params.dig(:exam_schedule, :course_id)
  #
   # # Fetch courses based on selected program or default to empty array
   # courses = selected_program_id.present? ? Course.by_program(selected_program_id).map { |c| [c.course_title, c.id] } : []
  #
   # # Fetch sections based on selected course or default to empty array
   # sections = selected_course_id.present? ? Section.by_course(selected_course_id).map { |s| [s.section_full_name, s.id] } : []
  
    f.inputs do
      f.input :program, as: :select, collection: Program.all.pluck(:program_name, :id)
      f.input :course, as: :select, collection: [] # Start with empty options
      f.input :section, as: :select, collection: [] # Start with empty options
      f.input :day_of_week
      f.input :start_time
      f.input :end_time
      f.input :classroom
      f.input :class_type
      f.input :instructor_name
    end
    f.actions
  end
  
  #controller do
  #  before_action :include_custom_js, only: [:new, :edit]
#
  #  private
#
  #  def include_custom_js
  #    @javascript = "exam_schedules"
  #  end
  #end
end

