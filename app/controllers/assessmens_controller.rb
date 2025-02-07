class AssessmensController < ApplicationController
  before_action { @disable_nav = true }

  def index
    course_id = params[:course_id]
    section_id = params[:section]
    current_admin_user = params[:current_admin_user]

    students = Student.includes(:course_registrations).where(section_id: section_id).map do |student|
      {
        id: student.id,
        first_name: student.first_name,
        middle_name: student.middle_name,
        last_name: student.last_name,
        year: student.year,
        semester: student.semester,
        student_id: student.student_id,
        course_registrations: student.course_registrations.map { |cr| { id: cr.id, course_id: cr.course_id } }
      }
    end

    assessment_plans = AssessmentPlan.where(course_id: course_id)

    render json: { student: students.to_json, assessment_plan: assessment_plans.to_json }
  end

  def scoped_collection
    super.includes(:student, :course)
  end

  def edit
    @assessment = Assessment.includes(:student).find(params[:id])
  end
  

  def update
    assessment = Assessment.find(params[:id])
    updates = params.require(:assessment).permit!
  
    # Replace the values in the assessment's value hash
    assessment.value.merge!(updates)
  
    assessment.status = 0 if assessment.final_grade? || assessment.incomplete?
  
    if assessment.save
      render json: { result: 'Updated', status: assessment }
    else
      render json: { result: assessment.errors.full_messages, status: 'failed' }
    end
  end
  
  def update_mark
    assessment = Assessment.find(params[:id])
    key = params[:key]
    result = params[:result]

    if assessment.value[key] != result
      assessment.value[key] = result
      assessment.status = 0 if assessment.final_grade? || assessment.incomplete?
      
      if assessment.save
        render json: { result: 'Updated', status: assessment }
      else
        render json: { result: assessment.errors.full_messages, status: 'failed' }
      end
    else
      render json: { result: 'No change', status: assessment }
    end
  end

  def batch_update
    assessment = Assessment.find(params[:id])
    updates = params[:updates]

    updates.each do |key, value|
      assessment.value[key] = value
    end

    assessment.status = 0 if assessment.final_grade? || assessment.incomplete?

    if assessment.save
      render json: { result: 'Updated', status: assessment }
    else
      render json: { result: assessment.errors.full_messages, status: 'failed' }
    end
  end

  def create
    assessment = Assessment.where(student_id: search_params[:student_id], course_id: search_params[:course_id],
                                  admin_user_id: search_params[:admin_user_id], course_registration_id: search_params[:course_registration_id]).last

    if assessment.present?
      if assessment.value.key?("#{search_params[:assessment_title].split(' ').join('_')}")
        render json: { result: 'You already set mark for this assessment plan, please go to edit page if you want to edit!', status: 'exist' }
      else
        assessment.value.merge!({ "#{search_params[:assessment_title].split(' ').join('_')}" => search_params[:result] })
        if assessment.save
          render json: { result: 'done', status: 'created' }
        else
          render json: { result: assessment.errors.full_messages, status: 'failed' }
        end
      end
    else
      assessment = Assessment.new(admin_user_id: search_params[:admin_user_id], student_id: search_params[:student_id],
                                  course_id: params[:course_id], course_registration_id: search_params[:course_registration_id], value: { "#{search_params[:assessment_title].split(' ').join('_')}" => search_params[:result] })
      if assessment.save
        render json: { result: 'done', status: 'created' }
      else
        render json: { result: assessment.errors.full_messages, status: 'failed' }
      end
    end
  end

  def bulk_create
    assessments = params[:assessments]
  
    Rails.logger.info("Received assessments: #{assessments}")
  
    begin
      ActiveRecord::Base.transaction do
        assessments.each do |assessment_params|
          Rails.logger.info("Processing assessment: #{assessment_params}")
  
          existing_assessment = Assessment.find_by(
            course_id: assessment_params[:course_id],
            student_id: assessment_params[:student_id],
            admin_user_id: assessment_params[:admin_user_id],
            course_registration_id: assessment_params[:course_registration_id]
          )
  
          if existing_assessment
            if existing_assessment.value.key?(assessment_params[:assessment_title].split(' ').join('_'))
              Rails.logger.info("Assessment for #{assessment_params[:assessment_title]} already exists, skipping.")
              next
            else
              existing_assessment.value.merge!(assessment_params[:assessment_title].split(' ').join('_') => assessment_params[:result])
              existing_assessment.save!
            end
          else
            new_assessment = Assessment.new(
              admin_user_id: assessment_params[:admin_user_id],
              student_id: assessment_params[:student_id],
              course_id: assessment_params[:course_id],
              course_registration_id: assessment_params[:course_registration_id],
              value: { assessment_params[:assessment_title].split(' ').join('_') => assessment_params[:result] }
            )
            new_assessment.save!
          end
        end
      end
      render json: { status: "success" }
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error("Record invalid: #{e.record.errors.full_messages}")
      render json: { status: "error", message: e.record.errors.full_messages }, status: :unprocessable_entity
    rescue => e
      Rails.logger.error("Error: #{e.message}")
      render json: { status: "error", message: e.message }, status: :unprocessable_entity
    end
  end
  

  def fetch_data
    students = Student.all.to_json
    assessment_plans = AssessmentPlan.all.to_json

    render json: { student: students, assessment_plan: assessment_plans }
  end

  def find_course
    admin_user_id = params[:current_admin_user]
    year = params[:year]
    semester = params[:semester]

    course_instructors = CourseInstructor.where(admin_user_id: admin_user_id, year: year, semester: semester)
    courses = Course.where(id: course_instructors.pluck(:course_id))
    programs = Program.where(id: courses.pluck(:program_id).uniq)
    sections = Section.where(program_id: programs.pluck(:id).uniq)

    results = courses.map do |course|
      {
        course: {
          id: course.id,
          course_title: course.course_title
        },
        program: programs.find { |p| p.id == course.program_id },
        sections: sections.select { |section| section.program_id == course.program_id }.map { |section| { id: section.id, name: section.section_full_name } }
      }
    end

    render json: results
  end

  def missing_assessments_report
    @report_data = CourseInstructor.joins(course: :program)
                                   .joins(:admin_user)
                                   .select('course_instructors.admin_user_id, courses.course_title, courses.year, courses.semester, programs.program_name AS program_name, admin_users.first_name, admin_users.last_name')
                                   .distinct
                                   .where('NOT EXISTS (SELECT 1 FROM assessments WHERE assessments.admin_user_id = course_instructors.admin_user_id AND assessments.course_id = course_instructors.course_id)')
                                   .order('admin_users.last_name, courses.course_title')
  
    respond_to do |format|
      format.html # This will render the missing_assessments_report.html.erb
      format.json { render json: @report_data }
    end
  end
  

  private

  def search_params
    params.permit(:course_id, :student_id, :course_registration_id, :assessment_title, :result, :admin_user_id)
  end
end
