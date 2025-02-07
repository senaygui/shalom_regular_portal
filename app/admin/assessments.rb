ActiveAdmin.register Assessment do
  permit_params :student_id, :course_id, :student_grade_id, :assessment_plan_id, :result, :created_by, :updated_by, :final_exam, :course_registration_id

  # Custom Filters
  filter :student_id, label: 'Student', as: :select, collection: proc { Student.all.map { |student| ["#{student.first_name} #{student.last_name}", student.id] } }
  filter :course_id, as: :search_select_filter, 
       url: proc {
         # Assuming you have a route that takes the current user's ID and returns the relevant courses
         admin_courses_path(current_admin_user_id: current_admin_user.id) 
       },
       fields: [:course_title, :id], 
       display_name: 'course_title', 
       minimum_input_length: 2, 
       order_by: 'created_at_asc'

  filter :course_program_id, as: :select, label: 'Program', collection: proc { Program.all.map { |program| [program.program_name, program.id] } }
  filter :student_section_id, as: :select, label: 'Section', collection: proc { Section.all.map { |section| [section.section_full_name, section.id] } }
  filter :student_academic_calendar_id, as: :select, label: 'Calendar', collection: proc { AcademicCalendar.all.map { |ac| [ac.calender_year, ac.id] } }
  filter :created_at 
  # Define scopes and batch actions
  scope :assessment_by_instructor, default: true, if: proc { current_admin_user.role == 'instructor' }
  scope :approved_by_instructor, if: proc { current_admin_user.role == 'department head' || current_admin_user.role == 'dean' }
  scope :approved_by_head, default: true, if: proc { current_admin_user.role == 'dean' }
  scope :incomplete_student
  scope :graded

  batch_action :approve_assessment_for, confirm: 'Are you sure?' do |ids|
    if current_admin_user.role == 'instructor'
      approve_accounter = 0
      incomplete_accounter = 0
    
      assessments = Assessment.where(id: ids, admin_user_id: current_admin_user.id, status: 0)
                              .includes(:student, :course)
    
      assessments.each do |assessment|
        instructor_assessment_plans = assessment.course.assessment_plans.where(admin_user_id: current_admin_user.id)
        non_empty_result_count = assessment.result.values.flat_map(&:values).reject(&:blank?).count
    
        if instructor_assessment_plans.count == non_empty_result_count
          assessment.update(status: 1, approved_by_instructor_id: current_admin_user.id)
          approve_accounter += 1
        else
          assessment.update(status: 4)
          incomplete_accounter += 1
        end
      end
    
      flash[:notice] = "Assessments approved: #{approve_accounter}, Incomplete: #{incomplete_accounter}"
      redirect_to admin_assessments_path
  
    elsif current_admin_user.role == 'department head'
      approve_accounter = 0
      incomplete_accounter = 0
      assessments = Assessment.includes(:student, :course)
                              .where(id: ids, status: [1,4], student: { department_id: current_admin_user.department_id })
    
      assessments.each do |assessment|
        instructor_ids = assessment.result.keys.map { |key| key.split('_').first }.uniq
    
        instructor_status = instructor_ids.map do |instructor_id|
          instructor_assessment_plans = assessment.course.assessment_plans.where(admin_user_id: instructor_id)
          non_empty_result_count = instructor_assessment_plans.count do |plan|
            key = "#{instructor_id}_#{plan.assessment_title}"
            !assessment.result[key].blank?
          end
    
          if instructor_assessment_plans.count == non_empty_result_count
            :complete
          else
            :incomplete
          end
        end
    
        if instructor_status.include?(:incomplete)
          assessment.update(status: 4)
          incomplete_accounter += 1
        else
          assessment.update(status: 2, approved_by_head_id: current_admin_user.id)
          approve_accounter += 1
        end
      end
    
      flash[:notice] = "Assessments approved: #{approve_accounter}, Incomplete: #{incomplete_accounter}"
      redirect_to admin_assessments_path
  
    elsif current_admin_user.role == 'dean'
      success_counter = 0
      error_counter = 0
  
      assessments = Assessment.where(id: ids, status: 2).includes(:student).includes(:course)
      assessments.each do |assessment|
        total = Assessment.total_mark(assessment.value)
        grade = Assessment.get_letter_grade(total)
        f_counter = if grade.first == 'F'
                      1
                    else
                      0
                    end
        student_grade = StudentGrade.new(student_id: assessment.student_id, course_id: assessment.course_id,
                                         course_registration_id: assessment.course_registration_id,
                                         department_id: assessment.student.department_id, program_id:
                                           assessment.student.program_id, letter_grade: grade.first, assesment_total:
                                           total, grade_point: grade.last, f_counter:)
        
        if student_grade.save
          assessment.update(status: 5)
          success_counter += 1
        else
          error_counter += 1
        end
      end
      redirect_to admin_assessments_path,
                  notice: "#{success_counter} #{'student'.pluralize(success_counter)} student grade generated and #{error_counter} #{'student'.pluralize(error_counter)} failed to generate grade "
    end            
  end
  
  batch_action :delete, confirm: 'Are you sure you want to delete these assessments?' do |ids|
    assessments = Assessment.where(id: ids)
    assessments.destroy_all
    flash[:notice] = "#{assessments.count} assessments were successfully deleted."
    redirect_to admin_assessments_path
  end
  
  #batch_action :approve_assessment_for, confirm: 'Are you sure?' do |ids|
  #  if current_admin_user.role == 'instructor'
  #    approve_accounter = 0
  #    incomplete_accounter = 0
  #  
  #    assessments = Assessment.where(id: ids, admin_user_id: current_admin_user.id, status: 0)
  #                            .includes(:student, :course)
  #  
  #    assessments.each do |assessment|
  #      # Fetch assessment plans created by the current admin user
  #      instructor_assessment_plans = assessment.course.assessment_plans.where(admin_user_id: current_admin_user.id)
  #      
  #      # Calculate non-empty result count for the current instructor
  #      non_empty_result_count = assessment.result.values.flat_map(&:values).reject(&:blank?).count
  #  
  #      # Debug logs
  #      puts "Assessment ID: #{assessment.id}"
  #      puts "Instructor Assessment Plans Count: #{instructor_assessment_plans.count}"
  #      puts "Non-empty Result Count: #{non_empty_result_count}"
  #      puts "Assessment Result: #{assessment.result.inspect}"
  #      
  #      if instructor_assessment_plans.count == non_empty_result_count
  #        assessment.update(status: 1)
  #        approve_accounter += 1
  #        puts "Assessment ID #{assessment.id} marked as complete (status: 1)"
  #      else
  #        assessment.update(status: 4)
  #        incomplete_accounter += 1
  #        puts "Assessment ID #{assessment.id} marked as incomplete (status: 4)"
  #      end
  #    end
  #  
  #    flash[:notice] = "Assessments approved: #{approve_accounter}, Incomplete: #{incomplete_accounter}"
  #    redirect_to admin_assessments_path
  #
  #  elsif current_admin_user.role == 'department head'
  #    approve_accounter = 0
  #    incomplete_accounter = 0
  #    assessments = Assessment.includes(:student, :course)
  #                            .where(id: ids, status: [1,4], student: { department_id: current_admin_user.department_id })
  #  
  #    assessments.each do |assessment|
  #      # Debugging: Log the keys of assessment.result
  #      Rails.logger.info "Assessment Result Keys: #{assessment.result.keys.inspect}"
  #      
  #      # Collect only relevant instructor IDs based on specific assessment's result keys
  #      instructor_ids = assessment.result.keys.map { |key| key.split('_').first }.uniq
  #      
  #      instructor_status = instructor_ids.map do |instructor_id|
  #        # Fetching the instructor's specific assessment plans
  #        instructor_assessment_plans = assessment.course.assessment_plans.where(admin_user_id: instructor_id)
  #  
  #        # Debugging
  #        Rails.logger.info "Instructor ID: #{instructor_id}"
  #        Rails.logger.info "Assessment Plans Count: #{instructor_assessment_plans.count}"
  #  
  #        # Adjusted logic to count non-empty result keys that match the instructor's assessment plans
  #        non_empty_result_count = instructor_assessment_plans.count do |plan|
  #          key = "#{instructor_id}_#{plan.assessment_title}"
  #          !assessment.result[key].blank?
  #        end
  #  
  #        Rails.logger.info "Non-empty Result Keys Count: #{non_empty_result_count}"
  #  
  #        assessment.result.each do |key, value|
  #          Rails.logger.info "Result Key: #{key}, Value: #{value}"
  #        end
  #  
  #        # Determine completeness
  #        if instructor_assessment_plans.count == non_empty_result_count
  #          :complete
  #        else
  #          :incomplete
  #        end
  #      end
  #  
  #      if instructor_status.include?(:incomplete)
  #        assessment.update(status: 4)
  #        incomplete_accounter += 1
  #      else
  #        assessment.update(status: 2)
  #        approve_accounter += 1
  #      end
  #    end
  #  
  #    flash[:notice] = "Assessments approved: #{approve_accounter}, Incomplete: #{incomplete_accounter}"
  #    redirect_to admin_assessments_path
#
  #  elsif current_admin_user.role == 'dean'
  #    success_counter = 0
  #    error_counter = 0
#
  #    assessments = Assessment.where(id: ids, status: 2).includes(:student).includes(:course)
  #    assessments.each do |assessment|
  #      total = Assessment.total_mark(assessment.value)
  #      grade = Assessment.get_letter_grade(total)
  #      f_counter = if grade.first == 'F'
  #                    1
  #                  else
  #                    0
  #                  end
  #      student_grade = StudentGrade.new(student_id: assessment.student_id, course_id: assessment.course_id,
  #                                       course_registration_id: assessment.course_registration_id,
  #                                       department_id: assessment.student.department_id, program_id:
  #                                         assessment.student.program_id, letter_grade: grade.first, assesment_total:
  #                                         total, grade_point: grade.last, f_counter:)
  #      
  #      if student_grade.save
  #        assessment.update(status: 5)
  #        success_counter += 1
  #      else
  #        error_counter += 1
  #      end
  #    end
  #    redirect_to admin_assessments_path,
  #                notice: "#{success_counter} #{'student'.pluralize(success_counter)} student grade generated and #{error_counter} #{'student'.pluralize(error_counter)} failed to generate grade "
  #  end            
  #end

  # Index View
  index do
    selectable_column
    column 'Student', sortable: 'student.first_name' do |n|
      "#{n.student.first_name} #{n.student.middle_name} #{n.student.last_name}"
    end
  
    column 'Course', sortable: 'course.course_title' do |c|
      c.course.course_title
    end
  
    column 'Remaining Assessment', sortable: true do |c|
      remaining_assessments = 0
    
      if current_admin_user.role == 'instructor'
        instructor_assessment_plans = c.course.assessment_plans.where(admin_user_id: current_admin_user.id)
        remaining_assessments = instructor_assessment_plans.count - c.value.size
      elsif current_admin_user.role == 'department head'
        department_instructor_ids = AdminUser.where(department_id: current_admin_user.department_id).pluck(:id)
        department_assessment_plans = c.course.assessment_plans.where(admin_user_id: department_instructor_ids)
        remaining_assessments = department_assessment_plans.count - c.value.size
      end
    
      remaining_assessments = remaining_assessments < 0 ? 0 : remaining_assessments
    
      span(remaining_assessments)
    end
  
    #column 'Approval Status', sortable: true do |c|
    #  case c.status
    #  when 1
    #    status_tag "Approved by #{c.approved_by_instructor&.email}", class: 'ok'
    #  when 2
    #    status_tag "Approved by #{c.approved_by_head&.email}", class: 'ok'
    #  when 5
    #    status_tag 'Finalized by Dean', class: 'ok'
    #  else
    #    status_tag 'Pending', class: 'warning'
    #  end
    #end
  
    column 'Total', width: '20%' do |c|
      outer_result_hash = c.value.is_a?(String) ? JSON.parse(c.value) : c.value
      total = 0
      if outer_result_hash.is_a?(Hash)
        outer_result_hash.each do |key, value|
          total += value.to_f
        end
      end
      div style: 'display: block; margin-bottom: 10px;' do
        span "Sum = #{total}"
      end
      div style: 'display: block;' do
        link_to 'Edit', edit_assessmen_path(c), class: 'button', target: '_blank'
      end
    end
  
    column 'Letter Grade', width: '20%' do |c|
      outer_result_hash = c.value.is_a?(String) ? JSON.parse(c.value) : c.value
      total = 0
      if outer_result_hash.is_a?(Hash)
        total = outer_result_hash.values.map(&:to_i).sum
      end
      grade = Assessment.get_letter_grade(total)
      div style: 'display: block; margin-bottom: 10px;' do
        span "#{grade.first}"
      end
    end
  
    actions
  end
  
  #index do
  #  # Columns
  #  selectable_column
  #  column 'Student', sortable: 'student.first_name' do |n|
  #    "#{n.student.first_name} #{n.student.middle_name} #{n.student.last_name}"
  #  end
  #
  #  column 'Course', sortable: 'course.course_title' do |c|
  #    c.course.course_title
  #  end
  #
  #  column 'Remaining Assessment', sortable: true do |c|
  #    remaining_assessments = 0
  #  
  #    if current_admin_user.role == 'instructor'
  #      instructor_assessment_plans = c.course.assessment_plans.where(admin_user_id: current_admin_user.id)
  #      remaining_assessments = instructor_assessment_plans.count - c.value.size
  #    elsif current_admin_user.role == 'department head'
  #      department_instructor_ids = AdminUser.where(department_id: current_admin_user.department_id).pluck(:id)
  #      department_assessment_plans = c.course.assessment_plans.where(admin_user_id: department_instructor_ids)
  #      remaining_assessments = department_assessment_plans.count - c.value.size
  #    end
  #  
  #    remaining_assessments = remaining_assessments < 0 ? 0 : remaining_assessments
  #  
  #    span(remaining_assessments)
  #  end
#
  #  # New Column: Instructor Approval Status
  #  column 'Instructor Approval Status', sortable: true do |c|
  #    case c.status
  #    when 1
  #      status_tag 'Approved by Instructor', class: 'ok'
  #    when 2
  #      status_tag 'Approved by Head', class: 'ok'
  #    when 5
  #      status_tag 'Finalized by Dean', class: 'ok'
  #    else
  #      status_tag 'Pending', class: 'warning'
  #    end
  #  end
  #  
  #  column 'Total', width: '20%' do |c|
  #    puts "Original c.value: #{c.value.inspect}"
  #    
  #    outer_result_hash = c.value.is_a?(String) ? JSON.parse(c.value) : c.value
  #    puts "Parsed outer_result_hash: #{outer_result_hash.inspect}"
  #    
  #    total = 0
  #  
  #    if outer_result_hash.is_a?(Hash)
  #      outer_result_hash.each do |key, value|
  #        puts "Key: #{key}, Value: #{value}, Value Class: #{value.class}"
  #        total += value.to_f
  #      end
  #    end
  #    
  #    puts "Calculated total: #{total}"
  #    
  #    div style: 'display: block; margin-bottom: 10px;' do
  #      span "Sum = #{total}"
  #    end
  #    div style: 'display: block;' do
  #      link_to 'Edit', edit_assessmen_path(c), class: 'button', target: '_blank'
  #    end
  #  end
  #  
  #  
  #  
  #  
  #  
  #  #column 'Total', width: '20%' do |c|
  #  #  total = c.value.map(&:last).map(&:to_f).sum
  #  #  div style: 'display: block; margin-bottom: 10px;' do
  #  #    span "Sum = #{total}"
  #  #  end
  #  #  div style: 'display: block;' do
  #  #    link_to 'Edit', edit_assessmen_path(c), class: 'button', target: '_blank'
  #  #  end
  #  #end
#
  #  #column 'Letter Grade', width: '20%' do |c|
  #  #  total = c.value.map(&:last).map(&:to_i).sum
  #  #  grade = Assessment.get_letter_grade(total)
  #  #  div style: 'display: block; margin-bottom: 10px;' do
  #  #    span "#{grade.first}"
  #  #  end
  #  #end
#
  #  column 'Letter Grade', width: '20%' do |c|
  #    # Check the structure of c.value
  #    puts "Original c.value: #{c.value.inspect}"
  #    
  #    # Parse c.value if it is a string
  #    outer_result_hash = c.value.is_a?(String) ? JSON.parse(c.value) : c.value
  #    
  #    # Check the structure after parsing
  #    puts "Parsed outer_result_hash: #{outer_result_hash.inspect}"
  #    
  #    # Initialize total to 0
  #    total = 0
  #  
  #    # Ensure outer_result_hash is a hash and iterate over its values
  #    if outer_result_hash.is_a?(Hash)
  #      total = outer_result_hash.values.map(&:to_i).sum
  #    end
  #    
  #    puts "Calculated total: #{total}"
  #    
  #    # Get the letter grade
  #    grade = Assessment.get_letter_grade(total)
  #    
  #    div style: 'display: block; margin-bottom: 10px;' do
  #      span "#{grade.first}"
  #    end
  #  end
  #  
  #  
  #  
  #  
  #  
  #
  #
  #  actions
  #end

  form do |_f|
    years = CourseInstructor.where(admin_user: current_admin_user).distinct.pluck(:year)
    sections = Section.all # Fetch all sections or filter based on criteria
    render 'assessment/new', { years:, sections: }
  end

  action_item :download_csv, only: :index do
    link_to 'Download CSV', download_csv_admin_assessments_path(format: :csv)
  end
  
  collection_action :download_csv, method: :get do
    csv_data = CSV.generate(headers: true) do |csv|
      courses = Assessment.includes(:student, :course).group_by(&:course_id)
      
      if courses.empty?
        puts "No assessments found"
      end
      
      courses.each do |course_id, assessments|
        course = Course.find(course_id)
        
        # Filter assessment plans by the current user
        assessment_plans = course.assessment_plans.where(user_id: current_admin_user.id)
        assessment_titles = assessment_plans.pluck(:assessment_title).sort
        
        if assessment_titles.empty?
          puts "No assessment titles found for course #{course.name} by user #{current_admin_user.id}"
        end
        
        # Initialize the header for each course
        header = ['student_id', 'NAME', 'course_name', 'YEAR', 'SEMESTER', 'TOTAL', 'Letter_Grade']
        csv << (header + assessment_titles)
  
        assessments.each do |assessment|
          student_id = assessment.student.student_id
          student_name = "#{assessment.student.first_name} #{assessment.student.middle_name} #{assessment.student.last_name}"
          course_name = assessment.course.course_title
          year = assessment.student.year
          semester = assessment.student.semester
  
          outer_result_hash = assessment.result.is_a?(String) ? JSON.parse(assessment.result) : assessment.result
          puts outer_result_hash.inspect
  
          # Calculate total
          total = outer_result_hash["value"].values.map(&:to_f).sum
          letter_grade = Assessment.get_letter_grade(total).first
  
          # Create a row with common values
          row = [student_id, student_name, course_name, year, semester, total, letter_grade]
  
          # Append assessment plan values for the specific course
          assessment_titles.each do |title|
            mark = outer_result_hash["value"] && outer_result_hash["value"][title] ? outer_result_hash["value"][title].to_f : ''
            puts "Title: #{title}, Mark: #{mark}"
            row << mark
          end
  
          csv << row
        end
      end
    end
  
    send_data csv_data, filename: "assessments-#{Date.today}.csv"
  end
  
  
  
  
  
  
  action_item :missing_assessments_report, only: :index do
    if current_admin_user.role == 'registrar head'
      link_to 'Missing Assessments Report', missing_assessments_report_assessmens_path, class: 'button'
    end
  end

  controller do
    def scoped_collection
      super.joins(:student, :course)
    end
  end
end
