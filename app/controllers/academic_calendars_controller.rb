class AcademicCalendarsController < ApplicationController
  before_action :set_academic_calendar, only: %i[show]

  def index
    @academic_calendars = AcademicCalendar.where(admission_type: current_student.admission_type,
                                                 study_level: current_student.study_level)
  end

  def show
  end
   
  def download_pdf
    academic_calendar = AcademicCalendar.find(params[:id])
    pdf = AcademicCalendarPdfGenerator.new(academic_calendar).render
    send_data pdf, filename: "academic_calendar_#{academic_calendar.id}.pdf", type: 'application/pdf', disposition: 'inline'
  end

  #def to_ethiopian_date(gregorian_date)
  #  # Ethiopian New Year usually starts on September 11 in Gregorian
  #  # Check if the current Gregorian year is a leap year
  #  is_gregorian_leap = Date.leap?(gregorian_date.year)
  #  new_year_offset = is_gregorian_leap ? 11 : 12
  #  ethiopian_year = gregorian_date.year - 8
  #  ethiopian_month = 1
  #  ethiopian_day = 1
  #
  #  # Adjust year if the date is before Ethiopian New Year
  #  if gregorian_date < Date.new(gregorian_date.year, 9, new_year_offset)
  #    ethiopian_year -= 1
  #  end
  #
  #  # Find the offset from the Ethiopian New Year in days
  #  ethiopian_new_year = Date.new(gregorian_date.year, 9, new_year_offset)
  #  days_difference = (gregorian_date - ethiopian_new_year).to_i
  #
  #  # Calculate Ethiopian month and day
  #  if days_difference >= 0
  #    ethiopian_month += days_difference / 30
  #    ethiopian_day += days_difference % 30
  #  else
  #    ethiopian_month = 13
  #    ethiopian_day += days_difference + 30
  #  end
  #
  #  # Adjust for the extra month of Pagumē (5 or 6 days) at the end of the year
  #  ethiopian_month += 1 if ethiopian_day > 30
  #  ethiopian_day = 1 if ethiopian_day > 30
  #
  #  "#{ethiopian_month}/#{ethiopian_day}/#{ethiopian_year}"
  #end
  
  private

  # Use callbacks to share common setup or constraints between actions.
  def set_academic_calendar
    @academic_calendar = AcademicCalendar.find(params[:id])
  end
end
