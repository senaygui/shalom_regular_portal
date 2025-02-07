class DocumentRequestsController < ApplicationController
  def new
    @document_request = DocumentRequest.new(document_type: params[:document_type])
    puts "Document Type in New Action: #{params[:document_type]}" # Debugging output
  end
  
  
  def create
    @document_request = DocumentRequest.new(document_request_params)
    puts "Document Type in Create Action: #{@document_request.document_type}"
    if @document_request.save
      redirect_to payment_document_request_path(@document_request), notice: 'Document request was successfully created. Please proceed to payment.'
    else
      render :new
    end
  end
  

  def payment
    @document_request = DocumentRequest.find(params[:id])

    puts "Study Level: #{@document_request.study_level}"
    puts "Admission Type: #{@document_request.admission_type}"
    puts "Document Type: #{@document_request.document_type}"
    # Find the corresponding payment information
    @college_payment = CollegePayment.find_by(
      study_level: @document_request.study_level,
      admission_type: @document_request.admission_type
    )
    case @document_request.document_type
    when 'To Whom It May Concern'
      @fee = @college_payment&.letter
    when 'Original Degree'
      @fee = @college_payment&.original_certificate
    when 'Temporary Certificate'
      @fee = @college_payment&.tempo
    when 'Student Copy'
      @fee = @college_payment&.student_copy
    when 'Official Transcript'
      @fee = @college_payment&.additional_student_copy
    # Add more cases for each document type
    else
      @fee = nil
    end
  
    if @fee.nil?
      Rails.logger.error "No fee found for the requested document type: #{@document_request.document_type}"
    else
      Rails.logger.info "Fee for #{@document_request.document_type}: #{@fee}"
    end
    # Debugging output to console
    #if @college_payment.present?
    #  puts "Found CollegePayment: #{@college_payment.inspect}"
    #else
    #  puts "No College Payment found for the given study level and admission type."
    #end
  end

  def upload_receipt
    @document_request = DocumentRequest.find_by(id: params[:id])
    
    if @document_request.nil?
      Rails.logger.error "DocumentRequest not found with ID: #{params[:id]}"
      redirect_to document_requests_path, alert: 'Document request not found.'
      return
    end
  
    if params[:document_request][:receipt].present?
      @document_request.receipt.attach(params[:document_request][:receipt])
    end
  
    if @document_request.save
      Rails.logger.info "Receipt successfully attached to DocumentRequest with ID: #{@document_request.id}"
      redirect_to @document_request, notice: 'Receipt uploaded successfully.'
    else
      Rails.logger.error "Failed to save DocumentRequest with ID: #{@document_request.id}, Errors: #{@document_request.errors.full_messages.join(', ')}"
      render :payment
    end
  end
  
  
    def track
      @document_request = DocumentRequest.find_by(track_number: params[:track_number])
      if @document_request
        redirect_to @document_request
      else
        flash[:alert] = "Track number not found."
        render :track_form
      end
    end
 
  

  def show
    @document_request = DocumentRequest.find(params[:id])
  end

  private

  def document_request_params
    params.require(:document_request).permit(:first_name, :middle_name, :last_name, :mobile_number, :email, :admission_type, :study_level, :program, :department, :student_status, :year_of_graduation, :document, :document_type)
  end
  
  def receipt_params
    params.require(:document_request).permit(:receipt)
  end
  
end
