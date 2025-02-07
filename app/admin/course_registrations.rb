ActiveAdmin.register CourseRegistration do
  menu parent: "Student managment"
  config.batch_actions = true
  permit_params :course_section, :enrollment_status, :course_section_id

  active_admin_import validate: true,
                      csv_options: { col_sep: ',' },
                      headers_rewrites: {
                        :'Student ID' => :student_id,
                        :'Program ID' => :program_id,
                        :'Semester Registration ID' => :semester_registration_id,
                        :'Department ID' => :department_id,
                        :'Course ID' => :course_id,
                        :'Academic Calendar ID' => :academic_calendar_id,
                        :'Section ID' => :section_id,
                        :'Semester' => :semester,
                        :'Year' => :year,
                        :'Student Full Name' => :student_full_name,
                        :'Enrollment Status' => :enrollment_status,
                        :'Course Title' => :course_title,
                        :'Academic Year' => :academic_year,
                        :'Drop Pending Status' => :drop_pending_status,
                        :'Is Active' => :is_active
                      },
                      before_import: ->(importer) {
                        # Access the CSV lines
                        csv_lines = importer.instance_variable_get(:@csv_lines)
                        headers = importer.instance_variable_get(:@headers)
                        puts "CSV Lines: #{csv_lines.inspect}"
                        puts "Headers: #{headers.inspect}"

                        if csv_lines.nil? || csv_lines.empty?
                          puts "Warning: csv_lines is nil or empty"
                        else
                          # Check the structure of the first CSV line
                          first_line = csv_lines.first
                          puts "First CSV line: #{first_line.inspect}"
                          
                          # Determine how to extract the IDs
                          id_key = headers.key('id') || 'id'
                          ids = csv_lines.map { |row| row[id_key] }.compact
                          puts "IDs to delete: #{ids.inspect}"
                          CourseRegistration.where(id: ids).delete_all
                        end
                      },
                      after_import: ->(importer) {
                        # Access the CSV lines
                        csv_lines = importer.instance_variable_get(:@csv_lines)
                        headers = importer.instance_variable_get(:@headers)
                        # Extract the IDs from the CSV lines
                        id_key = headers.key('id') || 'id'
                        imported_ids = csv_lines.map { |row| row[id_key] }.compact
                        puts "IDs imported: #{imported_ids.inspect}"
                        
                        CourseRegistration.where(id: imported_ids).update_all(updated_at: Time.zone.now)
                      }

  scoped_collection_action :scoped_collection_update, title: 'Set Section', form: -> do
    { section_id: Section.all.map { |section| [section.section_full_name, section.id] } }
  end

  controller do
    def scoped_collection
      super.where("enrollment_status = ?", "enrolled")
    end
  end

  batch_action "Generate Grade Sheet", method: :put, confirm: "Are you sure?" do |ids|
    CourseRegistration.find(ids).each do |course_registration|
      course_registration.add_grade
    end
    redirect_to collection_path, notice: "Grade Sheet Is Generated Successfully"
  end

  index do
    selectable_column
    column "Student Name" do |s|
      s.student.name.full
    end
    column "Academic Year" do |s|
      s.get_academic_year
    end
    column :id do |c|
      c.student.student_id
    end
    column :course_title
    column :program do |c|
      c.program.program_name
    end
    column :section_name do |c|
      c.section.section_short_name if c.section.present?
    end
    column "Created At", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions
  end
end
