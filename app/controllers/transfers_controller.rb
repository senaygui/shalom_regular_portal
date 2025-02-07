class TransfersController < ApplicationController
    before_action :set_student, only: [:new, :create]
    before_action :set_transfer #, only: [:new, :create]    
    def new
      @transfer = Transfer.new
      @available_programs = Program.where.not(id: @student.program_id)
      @available_departments = Department.where.not(id: @student.department_id)
    end
  
    def create
      @transfer = Transfer.new(transfer_params)
      @transfer.assign_attributes(
        student: @student,
        year: @student.year,
        semester: @student.semester,
        department: @student.department,
        program: @student.program,
        section: @student.section,
        academic_calendar: @student.academic_calendar
      )
  
      if @transfer.save
        redirect_to root_path, notice: 'Transfer request was successfully created.'
      else
        @available_programs = Program.where.not(id: @student.program_id)
        @available_departments = Department.where.not(id: @student.department_id)
        render :new
      end
    end

    def process_course_exemption
        if @transfer.present?
          @transfer.update(course_exemption_processed: true)
          redirect_to new_program_exemption_path, notice: 'You can now create your course exemption request.'
        else
          Rails.logger.debug("Transfer not found with ID: #{params[:id]}")
          redirect_to root_path, alert: 'Transfer not found.'
        end
    end
  
    private
  
    def set_transfer
        @transfer = Transfer.find_by(id: params[:id])
        Rails.logger.debug("set_transfer method called with ID: #{params[:id]}, found transfer: #{@transfer.inspect}")
    end

    def set_student
      @student = current_student
    end
  
    def transfer_params
      params.require(:transfer).permit(:new_program_id, :new_department_id, :reason, :new_department_head, :new_department_head_approval, :new_department_head_approval_date, :dean_approval, :dean_name, :dean_approval_date, :registrar_approval, :registrar_name, :registrar_approval_date, :date_of_transfer, :updated_by)
    end
  end
  