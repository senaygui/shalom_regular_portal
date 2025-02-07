ActiveAdmin.register MakeupExam do
  menu parent: "Add-ons"
  permit_params :updated_by, :created_by, :section_id, :academic_calendar_id, :student_id, :course_id, :section_id, :semester, :previous_result_total, :previous_letter_grade, :current_result_total, :current_letter_grade, :reason, :instructor_approval, :instructor_name, :instructor_date_of_response, :registrar_approval, :registrar_name, :registrar_date_of_response, :dean_approval, :dean_name, :dean_date_of_response, :department_approval, :department_head_name, :department_head_date_of_response, :academic_affair_approval, :academic_affair_name, :academic_affair_date_of_response, :course_registration_id, :student_grade_id, :assessment_id, :add_mark, :course_section_id, :program_id, :department_id, :year, :attachment, :receipt 

  controller do
    def scoped_collection
      if current_admin_user.role == 'instructor'
        MakeupExam.where(department_approval: 'approved')
      else
        MakeupExam.all
      end
    end
  end

  batch_action :approve_instructor, if: proc { current_admin_user.role == "instructor" || current_admin_user.role == "admin" }, confirm: "Are you sure?" do |ids|
    MakeupExam.find(ids).each do |makeup|
      makeup.update(instructor_approval: "approved", instructor_name: current_admin_user.name.full, instructor_date_of_response: Time.zone.now)
    end
    redirect_to collection_path, alert: "The selected have been approved by the instructor."
  end

  batch_action :deny_instructor, if: proc { current_admin_user.role == "instructor" || current_admin_user.role == "admin" }, confirm: "Are you sure?" do |ids|
    MakeupExam.find(ids).each do |makeup|
      makeup.update(instructor_approval: "denied", instructor_name: current_admin_user.name.full, instructor_date_of_response: Time.zone.now)
    end
    redirect_to collection_path, alert: "The selected have been denied by the instructor."
  end

  # Batch action for department approval
  batch_action :approve_department, if: proc { current_admin_user.role == "department head" || current_admin_user.role == "admin" }, confirm: "Are you sure?" do |ids|
    MakeupExam.find(ids).each do |makeup|
      makeup.update(department_approval: "approved", department_head_name: current_admin_user.name.full, department_head_date_of_response: Time.zone.now)
    end
    redirect_to collection_path, alert: "The selected have been approved by the department."
  end
  
  batch_action :deny_department, if: proc { current_admin_user.role == "department head" || current_admin_user.role == "admin" }, confirm: "Are you sure?" do |ids|
    MakeupExam.find(ids).each do |makeup|
      makeup.update(department_approval: "denied", department_head_name: current_admin_user.name.full, department_head_date_of_response: Time.zone.now)
    end
    redirect_to collection_path, alert: "The selected have been denied by the instructor."
  end

  # Batch action for dean approval
  batch_action :approve_dean, if: proc { current_admin_user.role == "dean" || current_admin_user.role == "admin" }, confirm: "Are you sure?" do |ids|
    MakeupExam.find(ids).each do |makeup|
      makeup.update(dean_approval: "approved", dean_name: current_admin_user.name.full, dean_date_of_response: Time.zone.now)
    end
    redirect_to collection_path, alert: "The selected have been approved by the dean."
  end
  
  batch_action :deny_dean, if: proc { current_admin_user.role == "dean" || current_admin_user.role == "admin" }, confirm: "Are you sure?" do |ids|
    MakeupExam.find(ids).each do |makeup|
      makeup.update(dean_approval: "denied", dean_name: current_admin_user.name.full, dean_date_of_response: Time.zone.now)
    end
    redirect_to collection_path, alert: "The selected have been denied by the instructor."
  end

  # Batch action for registrar approval
  batch_action :approve_registrar, if: proc { current_admin_user.role == "registrar head" || current_admin_user.role == "admin" }, confirm: "Are you sure?" do |ids|
    MakeupExam.find(ids).each do |makeup|
      makeup.update(registrar_approval: "approved", registrar_name: current_admin_user.name.full, registrar_date_of_response: Time.zone.now)
    end
    redirect_to collection_path, alert: "The selected have been approved by the registrar."
  end

  batch_action :deny_registrar, if: proc { current_admin_user.role == "registrar head" || current_admin_user.role == "admin" }, confirm: "Are you sure?" do |ids|
    MakeupExam.find(ids).each do |makeup|
      makeup.update(registrar_approval: "denied", registrar_name: current_admin_user.name.full, registrar_date_of_response: Time.zone.now)
    end
    redirect_to collection_path, alert: "The selected have been denied by the instructor."
  end

  index do
    selectable_column
    column :student_name, sortable: true do |n|
      "#{n.student.first_name.upcase} #{n.student.middle_name.upcase} #{n.student.last_name.upcase}"
    end
    column :ID, sortable: true do |n|
      n.student.student_id
    end
    column "Course" do |pd|
      pd.course.course_title
    end
    column "Attachment" do |me|
      if me.receipt.attached?
        link_to "View Receipt", url_for(me.receipt)
      else
        "No Receipt"
      end
    end
    column "Academic Year", sortable: true do |n|
      link_to n.academic_calendar.calender_year, admin_academic_calendar_path(n.academic_calendar)
    end
    column :year
    column :semester
    column "Status" do |pd|
      status_tag pd.status
    end
    column "Program" do |pd|
      pd.program.program_name
    end
    column "Department" do |pd|
      pd.department.department_name
    end
    column "Created At", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions
  end

  filter :student_id, as: :search_select_filter, url: proc { admin_students_path },
         fields: [:student_id, :id], display_name: 'student_id', minimum_input_length: 2,
         order_by: 'id_asc'
  filter :academic_calendar_id, as: :search_select_filter, url: proc { admin_academic_calendars_path },
         fields: [:calender_year, :id], display_name: 'calender_year', minimum_input_length: 2,
         order_by: 'id_asc'
  filter :year
  filter :semester
  filter :department_id, as: :search_select_filter, url: proc { admin_departments_path },
         fields: [:department_name, :id], display_name: 'department_name', minimum_input_length: 2,
         order_by: 'id_asc'
  filter :program_id, as: :search_select_filter, url: proc { admin_programs_path },
         fields: [:program_name, :id], display_name: 'program_name', minimum_input_length: 2,
         order_by: 'id_asc'
  filter :course_id, as: :search_select_filter, url: proc { admin_courses_path },
         fields: [:course_title, :id], display_name: 'course_title', minimum_input_length: 2,
         order_by: 'created_at_asc'
  filter :section_id, as: :search_select_filter, url: proc { admin_program_sections_path },
         fields: [:section_full_name, :id], display_name: 'section_full_name', minimum_input_length: 2,
         order_by: 'created_at_asc'
  filter :instructor_approval
  filter :registrar_approval
  filter :dean_approval
  filter :department_approval
  filter :academic_affair_approval
  filter :status
  filter :created_at
  filter :updated_at
  filter :created_by
  filter :updated_by

  form do |f|
    f.semantic_errors
    f.inputs "Makeup Exam Request" do
      if f.object.new_record? && ((current_admin_user.role == "registrar head")) || (current_admin_user.role == "admin") && (params[:course_id].present?)

        f.input :assessment_id, as: :select, collection: Assessment.where(student_grade_id: params[:student_grade_id]).map {|assess| [assess.assessment_plan.assessment_title, assess.id]}
        f.input :reason, label: "Student Reason"
        f.input :academic_calendar_id, as: :hidden, input_html: { value: params[:academic_calendar_id] }
        f.input :student_id, as: :hidden, input_html: { value: params[:student_id] }
        f.input :course_id, as: :hidden, input_html: { value: params[:course_id] }
        f.input :section_id, as: :hidden, input_html: { value: params[:section_id] }
        f.input :course_registration_id, as: :hidden, input_html: { value: params[:course_registration_id] }
        f.input :student_grade_id, as: :hidden, input_html: { value: params[:student_grade_id] }
        f.input :program_id, as: :hidden, input_html: { value: params[:program_id] }
        f.input :department_id, as: :hidden, input_html: { value: params[:department_id] }
        f.input :semester, as: :hidden, input_html: { value: params[:semester] }
        f.input :year, as: :hidden, input_html: { value: params[:year] }
        f.input :previous_result_total, as: :hidden, input_html: { value: StudentGrade.where(id: params[:student_grade_id]).pluck(:assesment_total) }
        f.input :previous_letter_grade, as: :hidden, input_html: { value: StudentGrade.where(id: params[:student_grade_id]).pluck(:letter_grade) }
        f.input :created_by, as: :hidden, input_html: { value: current_admin_user.name.full }
      end
      if !f.object.new_record?
        f.input :updated_by, as: :hidden, input_html: { value: current_admin_user.name.full }
        if (current_admin_user.role == "department head") || (current_admin_user.role == "admin")
          f.input :department_approval, as: :select, collection: ["pending", "approved", "denied"], include_blank: false
          f.input :department_head_name, as: :hidden, input_html: { value: current_admin_user.name.full }
          f.input :department_head_date_of_response, as: :hidden, input_html: { value: Time.zone.now }
        end
        if (current_admin_user.role == "registrar head") || (current_admin_user.role == "admin")
          f.input :registrar_approval, as: :select, collection: ["pending", "approved", "denied"], include_blank: false
          f.input :registrar_name, as: :hidden, input_html: { value: current_admin_user.name.full }
          f.input :registrar_date_of_response, as: :hidden, input_html: { value: Time.zone.now }
          f.input :add_mark, label: "Result"
        end
        if (current_admin_user.role == "dean") || (current_admin_user.role == "admin")
          f.input :dean_approval, as: :select, collection: ["pending", "approved", "denied"], include_blank: false
          f.input :dean_name, as: :hidden, input_html: { value: current_admin_user.name.full }
          f.input :dean_date_of_response, as: :hidden, input_html: { value: Time.zone.now }
        end
        if (current_admin_user.role == "instructor") || (current_admin_user.role == "admin")
          f.input :instructor_approval, as: :select, collection: ["pending", "approved", "denied"], include_blank: false
          f.input :instructor_name, as: :hidden, input_html: { value: current_admin_user.name.full }
          f.input :instructor_date_of_response, as: :hidden, input_html: { value: Time.zone.now }
        end
        if (current_admin_user.role == "academic affair") || (current_admin_user.role == "admin")
          f.input :academic_affair_approval, as: :select, collection: ["pending", "approved", "denied"], include_blank: false
          f.input :academic_affair_name, as: :hidden, input_html: { value: current_admin_user.name.full }
          f.input :academic_affair_date_of_response, as: :hidden, input_html: { value: Time.zone.now }
        end
      end
    end
    f.actions
  end

  show title: proc { |makeup_exam| truncate("#{makeup_exam.student.first_name.upcase} #{makeup_exam.student.middle_name.upcase} #{makeup_exam.student.last_name.upcase}", length: 50) } do
    columns do
      column do
        panel "Student information" do
          attributes_table_for makeup_exam do
            row :student_name, sortable: true do |n|
              "#{n.student.first_name.upcase} #{n.student.middle_name.upcase} #{n.student.last_name.upcase}"
            end
            row :ID, sortable: true do |n|
              n.student.student_id
            end
            row "Faculty" do |pd|
              pd.department.faculty.faculty_name
            end
            row "Department" do |pd|
              pd.department.department_name
            end
            row "Program" do |pd|
              pd.program.program_name
            end
            row :admission_type do |pd|
              pd.program.admission_type
            end
            row :study_level do |pd|
              pd.program.study_level
            end
            row "Academic Year", sortable: true do |n|
              link_to n.academic_calendar.calender_year, admin_academic_calendar_path(n.academic_calendar)
            end
            row :year
            row :semester
            row "Status" do |pd|
              status_tag pd.status
            end
          end
        end
      end

      column do
        panel "Grading Change Request information" do
          attributes_table_for makeup_exam do
            row "Course" do |pd|
              pd.course.course_title
            end

            row :reason
            row :created_at
            row :updated_at
            row :created_by
            row :updated_by
          end
        end
      end

      column do
        panel "Makeup Exam Request Approval Status" do
          attributes_table_for makeup_exam do
            row :department_approval do |c|
              status_tag c.department_approval
            end
            row :department_head_name
            row :department_head_date_of_response
            row :registrar_approval do |c|
              status_tag c.registrar_approval
            end
            row :registrar_name
            row :registrar_date_of_response
            row :dean_approval do |c|
              status_tag c.dean_approval
            end
            row :dean_name
            row :dean_date_of_response
            row :instructor_approval do |c|
              status_tag c.instructor_approval
            end
            row "Attachment" do |me|
              if me.receipt.attached?
                link_to me.receipt.filename.to_s, url_for(me.receipt)
              else
                "No reciept"
              end
            end
            row :instructor_name
            row :instructor_date_of_response
            row :academic_affair_approval do |c|
              status_tag c.academic_affair_approval
            end
            row :academic_affair_name
            row :academic_affair_date_of_response
          end
        end
      end
    end
  end
end 

  #batch_action :approve_selected, form: proc {
  #  if current_admin_user.role == 'registrar head'
  #    form do |f|
  #      f.input :registrar_approval, as: :select, collection: ["approved"], include_blank: false
  #    end
  #  elsif current_admin_user.role == 'department head'
  #    form do |f|
  #      f.input :department_approval, as: :select, collection: ["approved"], include_blank: false
  #    end
  #  elsif current_admin_user.role == 'dean'
  #    form do |f|
  #      f.input :dean_approval, as: :select, collection: ["approved"], include_blank: false
  #    end
  #  elsif current_admin_user.role == 'academic affair'
  #    form do |f|
  #      f.input :academic_affair_approval, as: :select, collection: ["approved"], include_blank: false
  #    end
  #  end
  #} do |ids|
  #  if current_admin_user.role == 'registrar head'
  #    MakeupExam.where(id: ids).update_all(registrar_approval: 'approved', registrar_name: current_admin_user.name.full, registrar_date_of_response: Time.zone.now)
  #  elsif current_admin_user.role == 'department head'
  #    MakeupExam.where(id: ids).update_all(department_approval: 'approved', department_head_name: current_admin_user.name.full, department_head_date_of_response: Time.zone.now)
  #  elsif current_admin_user.role == 'dean'
  #    MakeupExam.where(id: ids).update_all(dean_approval: 'approved', dean_name: current_admin_user.name.full, dean_date_of_response: Time.zone.now)
  #  elsif current_admin_user.role == 'academic affair'
  #    MakeupExam.where(id: ids).update_all(academic_affair_approval: 'approved', academic_affair_name: current_admin_user.name.full, academic_affair_date_of_response: Time.zone.now)
  #  end
  #  redirect_to collection_path, alert: "Makeup exams have been approved."
  #end
#
  #batch_action :delete_selected, if: proc { current_admin_user.role == 'admin' } do |ids|
  #  MakeupExam.where(id: ids).destroy_all
  #  redirect_to collection_path, alert: "Makeup exams have been deleted."
  #end
#end