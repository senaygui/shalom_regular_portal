class AddCoursesController < ApplicationController
  def index
    #@next_courses = []
    #@added_courses = []
    @course_having_f = StudentGrade.where(student: current_student).where('f_counter <= 2').where(letter_grade: 'F').or( StudentGrade.where(student: current_student).where(letter_grade: 'f')).includes(:course)
    @courses = Dropcourse.drop_course_approved.or(Dropcourse.drop_course_applied).includes(:course)
    if current_student.semester == 1
     @next_courses = Course.where(program_id: current_student.program_id).where("year >= ?", current_student.year).where(semester: 2)
    else
      @next_courses = Course.where(program_id: current_student.program_id).where("year > ?", current_student.year)
    end
    @added_courses = AddCourse.approved.where(student_id: current_student.id).includes(:course).includes(:department)
    #@added_courses + @next_courses
    current_total_credit_hour = CourseRegistration.where(student: current_student, semester: current_student.semester, year: current_student.year).includes(:course).active_yes.sum {|c| c.course.credit_hour}
    if current_student.admission_type == 'regular' && current_student.study_level="undergraduate"
      @allowed_credit_hour = 22 - current_total_credit_hour
    elsif current_student.admission_type == 'extension' && current_student.study_level = "undergraduate"
      @allowed_credit_hour = 13 - current_total_credit_hour
    elsif current_student.admission_type == "regular" && current_student.study_level = "graduate"
      @allowed_credit_hour = 12 - current_total_credit_hour
    end
  end
end
