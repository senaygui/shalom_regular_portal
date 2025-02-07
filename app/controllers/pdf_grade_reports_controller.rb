class PdfGradeReportsController < ApplicationController
  # before_action :set_filter
  def index
    @disable_nav = true
    @department = Department.select(:department_name, :id)
    #@academic_calendar = AcademicCalendar.select(:calender_year, :id)
    @academic_calendars = AcademicCalendar.all.to_a

  end

  def prepare_pdf
    department = params[:department][:name]
    year = params[:year]
    study_level = params[:study_level]
    semester = params[:semester]
    academic_calendar_id = params[:academic_calendar][:id]
    #study_level = params[:study_level]
    #students = GradeReport.where(section_id: section).where(department_id: department).where(year: year).where(semester: semester)
    #students = GradeReport.where(department_id: department).where(year: year).where(semester: semester)
    students = GradeReport.where(study_level: study_level).where(department_id: department).where(year: year).where(semester: semester).where(academic_calendar_id: academic_calendar_id)
    redirect_to pdf_gread_report_url, alert: "We could not find a student matching your search criteria. Please try again" if students.empty?
    if students.any?
      respond_to do |format|
        format.html
        format.pdf do
          pdf = StudentGradeReport.new(students)
          send_data pdf.render, filename: "student grade #{Time.zone.now}.pdf", type: "application/pdf", disposition: "inline"
        end
      end
    end
    
  end
end
