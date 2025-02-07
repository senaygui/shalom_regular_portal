ActiveAdmin.register UneditableCourse do
  menu false # Hide from the main menu

  # Define any necessary configurations for this resource
  permit_params :uneditable_curriculum_id, :course_module_id, :program_id, :course_title, :course_code, 
                :course_description, :year, :semester, :course_starting_date, :course_ending_date, 
                :credit_hour, :lecture_hour, :lab_hour, :ects, :created_by, :last_updated_by

  # Optional: Customize the index and show pages if needed
  index do
    selectable_column
    column :course_title
    column :course_code
    column :credit_hour
    column :lecture_hour
    column :lab_hour
    column :ects
    actions
  end
end
