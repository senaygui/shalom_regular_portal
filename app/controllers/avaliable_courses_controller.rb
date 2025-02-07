#class AvaliableCoursesController < ApplicationController
#    before_action :course_params, only: [:create]
#  
#    def index
#      @course = Course.find(params[:course_id])
#      @drop_id = params[:drop_id]
#  
#      @available_courses = CourseRegistration.active_yes
#                                             .select('DISTINCT ON (department_id) *')
#                                             .includes(:course, :department, :section)
#                                             .where(course_title: @course.course_title)
#    end
#  
#    def create
#      drop = Dropcourse.find(course_params[:drop_id]) if params[:drop_id].present?
#      add_course = AddCourse.new(course_params)
#      if add_course.save
#        drop&.drop_course_applied!
#        redirect_to add_courses_path, notice: 'Course application was successful'
#      else
#        p add_course.errors.full_messages
#        redirect_to add_courses_path, alert: 'Something went wrong, please try again later'
#      end
#    end
#  
#    private
#  
#    def course_params
#      params.permit(:student_id, :course_id, :department_id, :section_id, :semester, :year, :drop_id, :credit_hour, :ects)
#    end
#  end
  



class AvaliableCoursesController < ApplicationController
  before_action :course_params
    def index
       @course = Course.find(params[:course_id])
       @drop_id = params[:drop_id]
       @available_courses = CourseRegistration.active_yes
                                            .select('DISTINCT ON (department_id) *')
                                            .includes(:course, :department, :section)
                                            .where(course_title: @course.course_title)
       #@available_courses = CourseRegistration.active_yes.distinct(:department_id).includes(:course).includes(:department).includes(:section).where(course_title: @course.course_title)
    end

    def create
        drop = Dropcourse.find(course_params[:drop_id]) if params[:drop_id].present?
        add_course = AddCourse.new(year: course_params[:year], dropcourse_id: course_params[:drop_id], semester: course_params[:semester], student_id: course_params[:student_id], course_id: course_params[:course_id], department_id: course_params[:department_id], section_id: course_params[:section_id], credit_hour: course_params[:credit_hour], ects: course_params[:ects])
        if add_course.save
         drop&.drop_course_applied!
         redirect_to add_courses_path, notice: 'Course application was successfully'
        else
            p add_course.errors.full_messages
         redirect_to add_courses_path, alert: 'Something went wrong, please try again later'
        end
    end

    private
    def course_params
        params.permit(:student_id, :course_id, :department_id, :section_id, :semester, :year, :drop_id, :credit_hour,:ects)
    end
end