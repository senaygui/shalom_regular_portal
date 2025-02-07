ActiveAdmin.register ProgramExemption do
  menu parent: "Add-ons"
  permit_params :course_title, :letter_grade, :course_code, :credit_hour, :department_approval, :dean_approval, :registrar_approval, :exemption_needed, :student_id

  batch_action "Approve application status by registrar", method: :put, confirm: "Are you sure?", if: proc { current_admin_user.role == "registrar head" || current_admin_user.role == "admin"} do |ids|
    ProgramExemption.where(id: ids).update_all(registrar_approval: "Approved by #{current_admin_user&.first_name} #{current_admin_user&.last_name}")
    redirect_to admin_program_exemptions_path, notice: "#{ids.size} #{"application".pluralize(ids.size)} approved"
  end

  batch_action "Reject application status by registrar", method: :put, confirm: "Are you sure?", if: proc { current_admin_user.role == "registrar head" || current_admin_user.role == "admin"} do |ids|
    ProgramExemption.where(id: ids).update_all(registrar_approval: "Rejected by #{current_admin_user&.first_name} #{current_admin_user&.last_name}")
    redirect_to admin_program_exemptions_path, notice: "#{ids.size} #{"application".pluralize(ids.size)} rejected"
  end

  batch_action "Approve application status by dean", method: :put, confirm: "Are you sure?", if: proc { current_admin_user.role == "dean" || current_admin_user.role == "admin"} do |ids|
    ProgramExemption.where(id: ids).update_all(dean_approval: "Approved by #{current_admin_user&.first_name} #{current_admin_user&.last_name}")
    redirect_to admin_program_exemptions_path, notice: "#{ids.size} #{"application".pluralize(ids.size)} approved"
  end

  batch_action "Reject application status by dean", method: :put, confirm: "Are you sure?", if: proc { current_admin_user.role == "dean" || current_admin_user.role == "admin"} do |ids|
    ProgramExemption.where(id: ids).update_all(dean_approval: "Rejected by #{current_admin_user&.first_name} #{current_admin_user&.last_name}")
    redirect_to admin_program_exemptions_path, notice: "#{ids.size} #{"application".pluralize(ids.size)} rejected"
  end

  batch_action "Approve application status by Department Head", method: :put, confirm: "Are you sure?", if: proc { current_admin_user.role == "department head" || current_admin_user.role == "admin" } do |ids|
    Exemption.where(id: ids).update(department_approval_status: 1, department_approval: "Approved by #{current_admin_user&.first_name} #{current_admin_user&.last_name} ")
    redirect_to admin_program_exemptions_path, notice: "#{ids.size} #{"applicant".pluralize(ids.size)} status approved"
  end

  batch_action "Reject application status by Department Head", method: :put, confirm: "Are you sure?", if: proc { current_admin_user.role == "department head" || current_admin_user.role == "admin"} do |ids|
    Exemption.where(id: ids).update(department_approval_status: 2, department_approval: "Rejected by #{current_admin_user&.first_name} #{current_admin_user&.last_name}")
    redirect_to admin_program_exemptions_path, notice: "#{ids.size} #{"applicant".pluralize(ids.size)} status rejected"
  end
  

  filter :course_title
  filter :course_code
  filter :created_at

  scope :all, default: true

  index do
    selectable_column
    column :student, sortable: true
    column :course_title, sortable: true
    column :letter_grade, sortable: true
    column :course_code, sortable: true
    column :credit_hour, sortable: true
    column :department_approval, sortable: true
    column :dean_approval, sortable: true
    column :registrar_approval, sortable: true
    actions
  end
end
