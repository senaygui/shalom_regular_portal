class ApplyGradeChangeController < ApplicationController
  def index
    unless current_student.semester == 1 && current_student.year == 1
      if current_student.semester==2
        # stundet = STud
      end
    end
  end
end
