class ExternalTransfersController < ApplicationController
  before_action :set_external_transfer, only: [:show, :approved, :edit, :destroy, :update, :approval]

  
  def filter_programs
    @programs = Program.where(admission_type: params[:admission_type], study_level: params[:study_level], department_id: params[:department_id])
    respond_to do |format|
      format.json { render json: @programs.select(:id, :program_name) }
    end
  end
  
  def new
    @external_transfer = ExternalTransfer.new
    @departments = Department.select(:id, :department_name)
    @programs = Program.all # Add this line to set @programs for the new form
  end

  #def fetch_courses
  #  external_transfer = ExternalTransfer.find(params[:id])
  #  program = external_transfer.program
#
  #  if program
  #    courses = program.courses
  #    render json: courses
  #  else
  #    render json: [], status: :not_found
  #  end
  #end

  # Ensure to permit `:id` in the routes if not already done
  def show
    external_transfer = ExternalTransfer.find(params[:id])
    render json: external_transfer
  end

  def edit
    @departments = Department.select(:id, :department_name)
    @programs = Program.all # Ensure @programs is available for the edit form
  end

  def approval
    @disable_nav = true
    @approved_by = params[:approved_by]
  end

  def search
    search_result = ExternalTransfer.find_by(previous_student_id: params[:query])
    if search_result.present?
      redirect_to external_transfer_path(search_result.id)
    else
      redirect_to new_external_transfer_path, alert: "No applicant found for this ID, please remember your student ID or if you didn't apply yet please apply first "
    end
  end

  def create
    #transfer = ExternalTransfer.new(external_transfer_params)
    #if transfer.save
    #  redirect_to external_transfer_path(transfer.id), notice: "Application was successfully sent!"
    #else
    #  render :new
    #end
    transfer = ExternalTransfer.new(external_transfer_params)
    if transfer.save
     redirect_to payment_external_transfer_path(transfer.id), notice: "Application was successfully sent! Please proceed with the payment."
    else
     render :new
    end
  end

  def payment
    
    @external_transfer = ExternalTransfer.find(params[:id])
    study_level = @external_transfer.study_level.strip.downcase
    admission_type = @external_transfer.admission_type.strip.downcase
   
    puts "Student Study Level: #{study_level}"
    puts "Student Admission Type: #{admission_type}"
  
    @college_payment = CollegePayment.where(
      "LOWER(TRIM(study_level)) = ? AND LOWER(TRIM(admission_type)) = ? ",
      study_level,
      admission_type
    ).first
  
    if @college_payment.nil?
      puts "No matching CollegePayment found."
    else
      puts "Matching CollegePayment found: #{@college_payment.inspect}"
    end
  end

  def approved
    respond_to do |format|
      if @external_transfer.update(external_transfer_params)
        format.html { redirect_to admin_externaltransfer_path, notice: "Your application was successfully updated." }
      else
        format.html { render :approval, status: :unprocessable_entity }
      end
    end
  end


  #def update
  #  respond_to do |format|
  #    if @external_transfer.update(external_transfer_params)
  #      if @external_transfer.receipt.attached?
  #        puts "Receipt successfully attached."
  #      else
  #        puts "Receipt not attached."
  #      end
  #      format.html { redirect_to external_transfer_path(@external_transfer.id), notice: "Your application was successfully updated." }
  #    else
  #      format.html { render :edit, status: :unprocessable_entity }
  #    end
  #  end
  #end
  
  def update
    if @external_transfer.update(external_transfer_params)
      if @external_transfer.receipt.attached?
        redirect_to external_transfer_path(@external_transfer), notice: "Receipt uploaded successfully."
      else
        flash[:alert] = "Please upload the receipt again."
        render :payment
      end
    else
      flash[:alert] = "There was an error with your submission. Please try again."
      render :payment
    end
  end
  
  def destroy
    @external_transfer.destroy
    respond_to do |format|
      format.html { redirect_to admission_path, notice: "Your application was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def external_transfer_params
    params.require(:external_transfer).permit(:first_name, :approved_by, :email, :message, :transcript, :study_level, :admission_type, :last_name, :department_id, :program_id, :previous_institution, :previous_student_id, :status, :finance_status, :receipt)
  end

  def set_external_transfer
    @external_transfer = ExternalTransfer.find(params[:id])
  end
end
