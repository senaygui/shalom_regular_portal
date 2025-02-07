class CoursesPdf < Prawn::Document
    def initialize(courses)
      super()
      @courses = courses
      header
      course_list
    end
  
    def header
      text "Courses Report", size: 30, style: :bold
      move_down 20
    end
  
    def course_list
      @courses.each do |course|
        text "Course Title: #{course.course_title}", size: 16
        text "Course Code: #{course.course_code}", size: 16
        #text "Description: #{course.course_description}", size: 16
        text "Year: #{course.year}", size: 16
        text "Semester: #{course.semester}", size: 16
        text "Credit Hour: #{course.credit_hour}", size: 16
        #text "Lecture Hour: #{course.lecture_hour}", size: 16
        #text "Lab Hour: #{course.lab_hour}", size: 16
        #text "ECTS: #{course.ects}", size: 16
        move_down 20
      end
    end
  end