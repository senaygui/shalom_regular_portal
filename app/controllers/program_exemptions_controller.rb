# app/controllers/program_exemptions_controller.rb
class ProgramExemptionsController < ApplicationController
    def new
      @program_exemption = ProgramExemption.new
    end
  
    def create
      @program_exemption = ProgramExemption.new(program_exemption_params)
      @program_exemption.student = current_student
      if @program_exemption.save
        redirect_to root_path, notice: 'Program exemption request created successfully.'
      else
        render :new
      end
    end
  
    private
  
    def program_exemption_params
      params.require(:program_exemption).permit(:course_title, :letter_grade, :course_code, :credit_hour, :department_approval, :dean_approval, :registrar_approval, :exemption_needed)
    end
  end
  