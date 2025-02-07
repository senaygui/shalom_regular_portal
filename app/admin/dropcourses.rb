ActiveAdmin.register Dropcourse do
  menu parent: "Add-ons",label: "Course Drop"


  permit_params :student_id, :status, :department_id, :approved_by, :semester, :year, :course_id
  filter :student
  filter :department_id, as: :search_select_filter, url: proc { admin_departments_path },
  fields: [:department_name, :id], display_name: 'department_name', minimum_input_length: 2,
  order_by: 'id_asc'

  filter :course_id, as: :search_select_filter, url: proc { admin_courses_path },
  fields: [:course_title, :id], display_name: 'course_title', minimum_input_length: 2,
  order_by: 'id_asc'
  filter :year
  filter :semester
  # filter :status, filters: [0, 1


  batch_action :approve, confirm: "Are you sure?" do |ids|
    drop_courses = Dropcourse.where(id: ids, status: 0)
    courses =  CourseRegistration.where(course_id: drop_courses.select(:course_id)).where(student_id: drop_courses.select(:student_id)).where(semester: drop_courses.select(:semester))
    courses.destroy_all
    
    if drop_courses.update(status: 1, approved_by: current_admin_user.name.full)
    redirect_to admin_dropcourses_path, notice: "#{ids.size} #{"course".pluralize(ids.size)} approved for drop"
    else
    redirect_to admin_dropcourses_path, alert: "Something went wrong. please check again"

    end
  end

  index do
    selectable_column
    column "Student Name", sortable: true do |c|
      c.student.name.full
    end
    column "Course Title", sortable: true do |c| 
      c.course.course_title
    end
    column "Department Name", sortable: true do |c|
      c.department.department_name
    end

    column :semester
    column :year
    column "Status" do |c|
      if c.drop_course_pending?
        status_tag c.status
      elsif c.drop_course_approved?
        status_tag "Approved but not taken"
      else
        status_tag "Course Taken"
      end
    end
    # actions
  end
end
