ActiveAdmin.register UneditableCurriculum do
  menu parent: "Program"

  permit_params :program_id, :curriculum_title, :curriculum_version, :total_course, :total_ects, :total_credit_hour, :active_status, :curriculum_active_date, :depreciation_date, :created_by, :last_updated_by

  # ✅ Index Page
  index do
    selectable_column
    column :curriculum_title
    column "Version", :curriculum_version
    column "Program", sortable: true do |d|
      link_to d.program.program_name, [:admin, d.program]
    end
    column "Courses", :total_course
    column "Credit hours", :total_credit_hour
    column "ECTS", :total_ects
    column :active_status do |s|
      status_tag s.active_status
    end
    column "Add At", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions defaults: true
  end

  # ✅ Filters
  filter :program_id, as: :search_select_filter, url: proc { admin_programs_path },
         fields: [:program_name, :id], display_name: 'program_name', minimum_input_length: 2,
         order_by: 'id_asc'
  filter :curriculum_title
  filter :curriculum_version
  filter :total_course
  filter :total_credit_hour
  filter :active_status
  filter :curriculum_active_date
  filter :depreciation_date
  filter :created_by
  filter :last_updated_by
  filter :created_at
  filter :updated_at

  # ✅ Show Page
  show title: :curriculum_title do
    tabs do
      # Curriculum Information Tab
      tab "Curriculum Information" do
        panel "Curriculum Information" do
          attributes_table_for uneditable_curriculum do
            row :program_name do |pr|
              link_to pr.program.program_name, admin_program_path(pr.program)
            end
            row :curriculum_title
            row :curriculum_version
            row :total_course
            row :total_ects
            row :total_credit_hour
            row :active_status
            row :curriculum_active_date
            row :depreciation_date
            row :created_by
            row :last_updated_by
            row :created_at
            row :updated_at
          end
        end
      end

      # ✅ Course Breakdown Tab
      tab "Course Breakdown" do
        panel "Course Breakdown List" do
          (1..uneditable_curriculum.program.program_duration).map do |year|
            panel "Class Year: Year #{year}" do
              (1..uneditable_curriculum.program.program_semester).map do |semester|
                panel "Semester: #{semester}" do
                  table_for uneditable_curriculum.uneditable_courses.where(year: year, semester: semester).order(:year, :semester) do
                    column "Course Title" do |course|
                      link_to course.course_title, admin_uneditable_course_path(course)
                    end
                    column "Module Code" do |course|
                      course.course_module.module_code
                    end
                    column "Course Code", :course_code
                    column "Credit Hour", :credit_hour
                    column "Lecture Hour", :lecture_hour
                    column "Lab Hour", :lab_hour
                    column "Contact Hour (ECTS)", :ects
                    column :created_by
                    column "Add At", sortable: true do |course|
                      course.created_at.strftime("%b %d, %Y")
                    end
                  end
                end
              end
            end
          end
        end
      end

      tab "Grade System" do
        columns do
          column do
            panel "Grading System Information" do
              if uneditable_curriculum.uneditable_grade_system
                attributes_table_for uneditable_curriculum.uneditable_grade_system do
                  row "Program" do |gs|
                    link_to gs.program.program_name, admin_program_path(gs.program)
                  end
                  row :admission_type do |gs|
                    gs.program.admission_type
                  end
                  row :study_level do |gs|
                    gs.study_level
                  end
                  row "Curriculum Version" do |gs|
                    gs.curriculum.curriculum_version
                  end
                  row :min_cgpa_value_to_pass
                  row :min_cgpa_value_to_graduate
                  row :remark
                  row :created_at
                  row :updated_at
                end
              else
                div do
                  "No grading system information available."
                end
              end
            end
          end
        end
      end
      
      

    end
  end
end
