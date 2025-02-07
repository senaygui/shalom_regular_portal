ActiveAdmin.register Notice do
  menu parent: "Add-ons", label: "Notices"

  permit_params :title, :body

  controller do
    def create
      @notice = Notice.new(permitted_params[:notice])
      @notice.admin_user = current_admin_user
      if @notice.save
        redirect_to admin_notice_path(@notice), notice: 'Notice was successfully created.'
      else
        render :new
      end
    end
  end

  index do
    selectable_column
    id_column
    column :title
    column :body
    column :created_at
    column :updated_at
    column :posted_by do |notice|
      "#{notice.admin_user&.first_name} #{notice.admin_user&.last_name}".strip

    end
    actions
  end

  form do |f|
    f.inputs 'Notice Details' do
      f.input :title
      f.input :body
    end
    f.actions
  end

  show do
    attributes_table do
      row :title
      row :body
      row :created_at
      row :updated_at
      row :posted_by do |notice|
        "#{notice.admin_user&.first_name} #{notice.admin_user&.last_name}".strip
      end
      
    end
  end
end
