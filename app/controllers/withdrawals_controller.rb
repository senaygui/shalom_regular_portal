class WithdrawalsController < ApplicationController
    before_action :set_student, only: [:new, :create]
  
    def new
      @withdrawal = Withdrawal.new
      @withdrawal.assign_attributes(
        student: @student,
        year: @student.year,
        semester: @student.semester,
        department: @student.department,
        program: @student.program,
        section: @student.section, 
        academic_calendar: @student.academic_calendar # Adjust this to fetch the current academic calendar
      )
    end
  
    def create
      @withdrawal = Withdrawal.new(withdrawal_params)
      @withdrawal.assign_attributes(
        student: @student,
        year: @student.year,
        semester: @student.semester,
        department: @student.department,
        program: @student.program,
        section: @student.section,
        academic_calendar: @student.academic_calendar # Adjust this to fetch the current academic calendar
      )
  
      if @withdrawal.save
        redirect_to root_path, notice: 'Withdrawal request was successfully created.'
      else
        render :new
      end
    end
  
    private
  
    def set_student
      @student = current_student # Assuming you have a way to fetch the current student's record
    end
  
    def withdrawal_params
      params.require(:withdrawal).permit(:reason_for_withdrawal, :other_reason, :last_class_attended, :fee_status)
    end
  end
  