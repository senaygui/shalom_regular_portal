class ExemptionsController < ApplicationController
  before_action :set_applicant_id, only: [:new, :create, :index, :edit, :update]

  before_action :get_approver, only: [:index, :edit, :new]
  before_action { @disable_nav = true }

  def index
    @exemption = Exemption.where(external_transfer: @applicant)
    # @approved_by = params[:approved_by]
  end

  def edit
    @exemption = Exemption.where(id: params[:id]).where(external_transfer: @applicant).last
    # @approved_by = params[:approved_by]
  end

  def new
    @exemption = Exemption.new
    # @approved_by = "#{params[:approved_by]}"
  end

  def create
    exemption = Exemption.new(exemption_params)
    exemption.external_transfer = @applicant
    
    # Debug: Check if course_id is set and if the Course can be found
    puts "Course ID: #{exemption.course_id}"
    
    course = Course.find_by(id: exemption.course_id)
    
    if course.nil?
      puts "Course not found with ID: #{exemption.course_id}"
    else
      exemption.course_code = course.course_code
      exemption.credit_hour = course.credit_hour
      exemption.course_title = course.course_title
      
      # Debug: Print out the values before saving
      puts "Course Code: #{exemption.course_code}"
      puts "Credit Hour: #{exemption.credit_hour}"
      puts "Course Title: #{exemption.course_title}"
    end
  
    if exemption.save
      puts "Exemption saved successfully!"
      redirect_to new_exemptions_path(@applicant, exemption.department_approval), notice: "Course exemptions were successfully created!"
    else
      # Debug: Print out errors if saving fails
      puts "Failed to save exemption: #{exemption.errors.full_messages.join(", ")}"
      render :new
    end
  end
  
  

  def update
    @exemption = Exemption.where(id: params[:id]).where(external_transfer: @applicant).last

    respond_to do |format|
      if @exception.update(external_transfer_params)
        format.html { redirect_to index_exemptions_path(@applicant, @approved), notice: "Your application was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    applicant = params[:applicant_id]

    @exemption = Exemption.where(id: params[:id]).where(external_transfer: applicant).last
    @approved_by = params[:approved_by]

    @exemption.destroy
    respond_to do |format|
      format.html { redirect_to index_exemptions_path(applicant, @approved_by), notice: "Course exemption was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  #def select_course
  #  @exemption = Exemption.find_or_initialize_by(id: params[:id])
  #  course = Course.find(params[:exemption][:course_id])
  #  
  #  # Assign the course attributes to the exemption
  #  @exemption.course_code = course.course_code
  #  @exemption.credit_hour = course.credit_hour
  #  @exemption.course_title = course.course_title
  #
  #  # Debug: Print out the values before saving
  #  puts "Course Code: #{@exemption.course_code}"
  #  puts "Credit Hour: #{@exemption.credit_hour}"
  #  puts "Course Title: #{@exemption.course_title}"
  #
  #  # Save the updated exemption record
  #  if @exemption.save
  #    puts "Exemption saved successfully!"
  #    redirect_to new_exemptions_path(@applicant, exemption.department_approval), notice: "Course exemptions were successfully created!"
  #  else
  #    # Debug: Print out errors if saving fails
  #    puts "Failed to save exemption: #{@exemption.errors.full_messages.join(", ")}"
  #    render :new
  #  end
  #end
  

  private

  def exemption_params
    params.require(:exemption).permit(:course_title, :department_approval, :letter_grade, :course_code, :credit_hour, :external_transfer_id, :course_id)
  end
  

  def set_applicant_id
    @applicant = ExternalTransfer.find(params[:applicant_id])
  end

  def get_approver
    @approved_by = params[:approved_by]
  end
end
