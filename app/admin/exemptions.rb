ActiveAdmin.register Exemption do
  menu parent: "Add-ons", label: "Exemption"
  permit_params :course_title, :letter_grade, :course_code, :credit_hour, :department_approval, :dean_approval, :registeral_approval, :exemption_needed, :external_transfer_id

  batch_action "Approve application status by registeral for", method: :put, confirm: "Are you sure?", if: proc { current_admin_user.role == "registrar head" || current_admin_user.role == "admin" } do |ids|
    Exemption.where(id: ids).update(registeral_approval_status: 1, registeral_approval: "Approved by #{current_admin_user&.first_name} #{current_admin_user&.last_name} ")
    redirect_to admin_exemptions_path, notice: "#{ids.size} #{"applicant".pluralize(ids.size)} status approved"
  end

  batch_action "Reject application status by registeral for", method: :put, confirm: "Are you sure?", if: proc { current_admin_user.role == "registrar head" || current_admin_user.role == "admin"} do |ids|
    Exemption.where(id: ids).update(registeral_approval_status: 2, registeral_approval: "Rejected by #{current_admin_user&.first_name} #{current_admin_user&.last_name}")
    redirect_to admin_exemptions_path, notice: "#{ids.size} #{"applicant".pluralize(ids.size)} status rejected"
  end

  batch_action "Approve application status by Department Head", method: :put, confirm: "Are you sure?", if: proc { current_admin_user.role == "department head" || current_admin_user.role == "admin" } do |ids|
    Exemption.where(id: ids).update(department_approval_status: 1, department_approval: "Approved by #{current_admin_user&.first_name} #{current_admin_user&.last_name} ")
    redirect_to admin_exemptions_path, notice: "#{ids.size} #{"applicant".pluralize(ids.size)} status approved"
  end

  batch_action "Reject application status by Department Head", method: :put, confirm: "Are you sure?", if: proc { current_admin_user.role == "department head" || current_admin_user.role == "admin"} do |ids|
    Exemption.where(id: ids).update(department_approval_status: 2, department_approval: "Rejected by #{current_admin_user&.first_name} #{current_admin_user&.last_name}")
    redirect_to admin_exemptions_path, notice: "#{ids.size} #{"applicant".pluralize(ids.size)} status rejected"
  end
  

  batch_action "Approve application status by dean for", method: :put, confirm: "Are you sure?", if: proc { current_admin_user.role == "dean" || current_admin_user.role == "admin"} do |ids|
    Exemption.where(id: ids).update(dean_approval_status: 1, dean_approval: "Approved by #{current_admin_user&.first_name} #{current_admin_user&.last_name} ")
    redirect_to admin_exemptions_path, notice: "#{ids.size} #{"applicant".pluralize(ids.size)} status approved"
  end

  batch_action "Reject application status by dean for", method: :put, confirm: "Are you sure?", if: proc { current_admin_user.role == "dean" || current_admin_user.role == "admin"} do |ids|
    Exemption.where(id: ids).update(dean_approval_status: 2, dean_approval: "Rejected by #{current_admin_user&.first_name} #{current_admin_user&.last_name}")
    redirect_to admin_exemptions_path, notice: "#{ids.size} #{"applicant".pluralize(ids.size)} status rejected"
  end
  
  filter :course_title
  filter :course_code
  filter :created_at

  scope :all, default: true

  index do
    selectable_column
    column "Applicant name", sortable: true do |c|
      c.external_transfer&.first_name + " " + c.external_transfer&.last_name
    end
    column :course_title, sortable: true
    column :letter_grade, sortable: true
    column :course_code, sortable: true
    column :credit_hour, sortable: true
    column :department_approval, sortable: true
    column :dean_approval, sortable: true
    column :registeral_approval, sortable: true
    actions
  end

  show do
    attributes_table do
      row :external_transfer do |exemption|
        exemption.external_transfer&.first_name + " " + exemption.external_transfer&.last_name
      end
      row :course_title
      row :letter_grade
      row :course_code
      row :credit_hour
      row :department_approval
      row :dean_approval
      row :registeral_approval
      row :exemption_needed
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

 # controller do
 #   before_action :setup_external_transfer, only: [:new, :edit]
#
 #   def setup_external_transfer
 #     @exemption = Exemption.new if action_name == 'new'
 #     @exemption = Exemption.find(params[:id]) if action_name == 'edit'
#
 #     if params[:external_transfer_id]
 #       @exemption.external_transfer = ExternalTransfer.find(params[:external_transfer_id])
 #     end
#
 #     if params[:exemption] && params[:exemption][:course_id].present?
 #       course = Course.find(params[:exemption][:course_id])
 #       @exemption.course_id = course.id
 #       @exemption.course_code = course.course_code
 #       @exemption.credit_hour = course.credit_hour
 #     end
 #   end
 # end

  form do |f|
    f.inputs "Exemption Details" do
      f.input :external_transfer_id, as: :select,
                                     collection: ExternalTransfer.all.collect { |et| [et.first_name + " " + et.last_name, et.id] },
                                     include_blank: false
  
      if f.object.external_transfer.present?
        f.inputs "Exempted Courses" do
          f.input :course_id, as: :select,
                              collection: f.object.external_transfer.program.courses.collect { |course| [course.course_title, course.id] },
                              include_blank: false
          #f.input :course_code, input_html: { disabled: true, value: f.object.course_code }
          #f.input :credit_hour, input_html: { disabled: true, value: f.object.credit_hour }
          #f.input :course_title, input_html: { disabled: true, value: f.object.course_title }
          f.input :letter_grade
        end
      end
    end
  
    f.actions
  end
  
  
  # Add a custom controller to populate the course code and credit hour dynamically
  #collection_action :courses_for_transfer, method: :get do
  #  external_transfer = ExternalTransfer.find(params[:external_transfer_id])
  #  courses = external_transfer.program.courses
  #  render json: { courses: courses.map { |course| { id: course.id, course_title: course.course_title } } }
  #end
  

  #controller do
  #  def new
  #    @exemption = Exemption.new
  #    @program_id = params[:program_id]
  #  end
  #end

end
