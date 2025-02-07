ActiveAdmin.register DocumentRequest do
  menu priority: 1
  config.batch_actions = true

  permit_params :first_name, :middle_name, :last_name, :mobile_number, :email, :admission_type, :study_level, :program, :department, :student_status, :year_of_graduation, :document, :status, :track_number, :receipt
  
  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :email
    column :program
    column :department
    column :student_status
    column :status
    column :track_number
    actions
  end

  filter :first_name
  filter :last_name
  filter :email
  filter :program
  filter :department
  filter :student_status
  filter :status
  filter :track_number

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :middle_name
      f.input :last_name
      f.input :mobile_number
      f.input :email
      f.input :admission_type, as: :select, collection: ['Regular', 'Extension']
      f.input :study_level, as: :select, collection: ['undergraduate', 'graduate']
      f.input :program, as: :select, collection: ['Environmental Science and Sustainable Development', 'Food Science and Technology', 'Business Management and Entrepreneurship', 'Marketing Management Regular', 'Computer Science Regular', 'Information Systems Regular', 'Information Technology Regular', 'Management Regular', 'Architecture Regular', 'Accounting & Finance Regular']
      f.input :department, as: :select, collection: ['Environmental Science and Sustainable Development', 'Food Science and Technology', 'Information Systems', 'Accounting & Finance', 'Management', 'Master of Arts in Organizational Leadership Program', 'Information Technology', 'Marketing Management', 'Business Management and Entrepreneurship', 'Architecture', 'Division of Common Courses', 'Masters of Business Administration', 'Computer Science']
      f.input :student_status, as: :select, collection: ['Active', 'Inactive', 'Graduated']
      f.input :year_of_graduation, as: :date_picker, if: proc { f.object.student_status == 'Graduated' }
      f.input :document, as: :file
      f.input :receipt, as: :file
      f.input :status, as: :select, collection: ['Pending', 'Approved', 'Rejected']
      f.input :track_number
    end
    f.actions
  end

  show do
    attributes_table do
      row :first_name
      row :middle_name
      row :last_name
      row :mobile_number
      row :email
      row :admission_type
      row :study_level
      row :program
      row :department
      row :student_status
      row :year_of_graduation
      row :document do |doc|
        if doc.document.attached?
          link_to doc.document.filename.to_s, rails_blob_path(doc.document, disposition: "attachment")
        end  
      end
      row :receipt do |doc|
        if doc.receipt.attached?
          link_to doc.receipt.filename.to_s, rails_blob_path(doc.receipt, disposition: "attachment")
        else
          "No receipt attached"
        end
      end
      
      row :status
      row :track_number
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  action_item :approve, only: :show do
    link_to 'Approve', approve_admin_document_request_path(document_request), method: :put if document_request.status == 'Pending'
  end

  action_item :reject, only: :show do
    link_to 'Reject', reject_admin_document_request_path(document_request), method: :put if document_request.status == 'Pending'
  end

  member_action :approve, method: :put do
    resource.update(status: 'Approved')
    redirect_to resource_path, notice: "Document Request Approved"
  end

  member_action :reject, method: :put do
    resource.update(status: 'Rejected')
    redirect_to resource_path, notice: "Document Request Rejected"
  end
end
