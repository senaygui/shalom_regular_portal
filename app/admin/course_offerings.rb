ActiveAdmin.register CourseOffering do
  
  menu false
  # Permitting parameters
  permit_params :course_id, :batch, :year, :semester, :course_starting_date, :course_ending_date, :credit_hour, :lecture_hour, :lab_hour, :ects, :major, :created_by, :last_updated_by

  # Customizing the index page
  index do
    selectable_column
    #id_column
    column :course do |course_offering|
      course_offering.course.course_title
    end
    column :batch
    column :year
    column :semester
    #column :course_starting_date
    #column :course_ending_date
    column :credit_hour
    #column :lecture_hour
    #column :lab_hour
    column :ects, label: "contact_hour"
    column :major
    column :created_by
    column :last_updated_by
    actions
  end

  # Customizing the form
  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :course, as: :search_select, url: admin_courses_path, fields: [:course_title], display_name: :course_title
      f.input :batch
      f.input :year
      f.input :semester
      f.input :course_starting_date, as: :datepicker
      f.input :course_ending_date, as: :datepicker
      f.input :credit_hour
      f.input :lecture_hour
      f.input :lab_hour
      f.input :ects
      f.input :major
      f.input :created_by
      f.input :last_updated_by
    end
    f.actions
  end

  # Customizing the show page
  show do
    attributes_table do
      row :course do |course_offering|
        course_offering.course.course_title
      end
      row :batch
      row :year
      row :semester
      row :course_starting_date
      row :course_ending_date
      row :credit_hour
      row :lecture_hour
      row :lab_hour
      row :ects
      row :major
      row :created_by
      row :last_updated_by
    end
    active_admin_comments
  end

  # Filtering options
  filter :course, collection: -> { Course.all.map { |course| [course.course_title, course.id] } }
  filter :batch
  filter :year
  filter :semester
  filter :credit_hour
  #filter :ects
end
