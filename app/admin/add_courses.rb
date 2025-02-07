ActiveAdmin.register AddCourse do
  menu parent: "Add-ons",label: "Course Adds"
  
  permit_params :student_id, :course_id, :department_id, :year, :semester, :status, :section_id, :credit_hour, :ects

  filter :student
  filter :department_id, as: :search_select_filter, url: proc { admin_departments_path },
  fields: [:department_name, :id], display_name: 'department_name', minimum_input_length: 2,
  order_by: 'id_asc'

  filter :course_id, as: :search_select_filter, url: proc { admin_courses_path },
  fields: [:course_title, :id], display_name: 'course_title', minimum_input_length: 2,
  order_by: 'id_asc'
  filter :year
  filter :semester
  batch_action :approve, confirm: "Are you sure?" do |ids|
    add_courses = AddCourse.where(id: ids, status: 0)
    drop_ids = add_courses.where.not(dropcourse_id: nil).select(:dropcourse_id)
    drop_courses =  Dropcourse.where(id: drop_ids)
    drop_courses.update(status: 2) if drop_courses.any?
    if add_courses.update(status: 1,  approved_by: current_admin_user.name.full) 
    redirect_to admin_add_courses_path, notice: "#{ids.size} #{"course".pluralize(ids.size)} approved for add"
    else
    redirect_to admin_add_courses_path, alert: "Something went wrong. please check again"
    end
  end

  batch_action :rejecte, confirm: "Are you sure?" do |ids|
    add_courses = AddCourse.where(id: ids, status: 0)
    drop_ids = add_courses.where.not(dropcourse_id: nil).select(:dropcourse_id)
    drop_courses =  Dropcourse.where(id: drop_ids)

  if add_courses.update(status: "pending", approved_by: current_admin_user.name.full) 
    drop_courses.update(status: 1) if drop_courses.any?
    redirect_to admin_add_courses_path, notice: "#{ids.size} #{"course".pluralize(ids.size)} pending for add"
  else
    redirect_to admin_add_courses_path, alert: "Something went wrong. please check again"
  end
  end
  index do
    selectable_column
    column "Student Name", sortable: true do |c|
      c.student.name.full
    end
    column "Student Department", sortable: true do |c|
       c.student.department.department_name
    end
    column "Student Year", sortable: true do |c|
      c.student.year
     end

     column "Student Semester", sortable: true do |c|
      c.student.semester
     end
    column "Course Title", sortable: true do |c| 
      c.course.course_title
    end

    column "Department to", sortable: true do |c|
      c.department.department_name
    end
    column "Section", sortable: true do |c|
      c.section&.section_full_name
    end
    column "Semester to" do |c|
      c.semester
    end
    column "Year to" do |c|
      c.year
    end
    column "Status" do |c|
      if c.pending?
        status_tag c.status
      elsif c.approved?
        status_tag c.status
      elsif c.rejected?
        status_tag c.status
      end
    end
    actions
  end
end
