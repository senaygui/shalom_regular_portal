ActiveAdmin.register CourseInstructor do
    # Ensure only department heads can access this page
    menu parent: "Department"

    controller do
      def scoped_collection
        if current_admin_user.role == 'department head'
          CourseInstructor.joins(course: { program: :department })
                          .where(departments: { id: current_admin_user.department_id })
        else
          CourseInstructor.all
        end
      end
    end
  
    index do
      selectable_column
      id_column
      column :admin_user do |course_instructor|
        "#{course_instructor.admin_user.first_name} #{course_instructor.admin_user.last_name}"
      end
      column :course do |course_instructor|
        course_instructor.course.course_title
      end
      column :academic_calendar
      column :section
      column :semester
      column :year
      actions
    end
  
    filter :admin_user, as: :select, collection: proc { AdminUser.where(role: 'department head') }
    filter :course
    filter :academic_calendar
    filter :section
    filter :semester
    filter :year
  
    form do |f|
      f.inputs do
        f.input :admin_user, as: :select, collection: AdminUser.where(role: 'instructor').map { |u| ["#{u.first_name} #{u.last_name}", u.id] }
        f.input :course
        f.input :academic_calendar
        f.input :section
        f.input :semester
        f.input :year
      end
      f.actions
    end
  end