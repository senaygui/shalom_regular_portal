ActiveAdmin.register AssessmentPlan do
  menu parent: "Program", if: proc { false }
  permit_params :id, :course_id, :assessment_title, 
  :assessment_weight, :created_by, :updated_by, 
  :final_exam, :admin_user_id,
                assessment_plans_attributes: 
                [:id, :course_id, :assessment_title, 
                :assessment_weight, :created_by, :updated_by,
                :final_exam, :admin_user_id, :_destroy]

  controller do
    def create
      @assessment_plan = AssessmentPlan.new(permitted_params[:assessment_plan])
      @assessment_plan.admin_user = current_admin_user
      if @assessment_plan.save
        redirect_to admin_course_path(@assessment_plan.course_id), notice: "Assessment plan created successfully."
      else
        flash[:error] = @assessment_plan.errors.full_messages.join(", ")
        redirect_back(fallback_location: admin_course_path(@assessment_plan.course_id))
      end
    end

    def update
      @assessment_plan = AssessmentPlan.find(params[:id])
      @assessment_plan.admin_user = current_admin_user
      if @assessment_plan.update(permitted_params[:assessment_plan])
        redirect_to admin_course_path(@assessment_plan.course_id), notice: "Assessment plan updated successfully."
      else
        flash[:error] = @assessment_plan.errors.full_messages.join(", ")
        redirect_back(fallback_location: admin_course_path(@assessment_plan.course_id))
      end
    end
  end

  index do
    selectable_column
    column :assessment_title
    column :assessment_weight
    column :course do |c|
      link_to c.course.course_title, admin_course_path(c.course)
    end
    column :program do |c|
      link_to c.course.program.program_name, admin_program_path(c.course.program)
    end
    column "Created At", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions
  end

  filter :course_id, as: :search_select_filter, url: proc { admin_courses_path },
         fields: [:course_title, :id], display_name: 'course_title', minimum_input_length: 2,
         order_by: 'created_at_asc'
  filter :assessment_title
  filter :assessment_weight
  filter :created_at
  filter :updated_at
  filter :created_by
  filter :updated_by

  form do |f|
  f.semantic_errors
  f.inputs "Assessment Plan" do
    f.has_many :assessment_plans, allow_destroy: true, new_record: true do |a|
      para "Debug: #{a.object.inspect}"
      if params[:course_id].present?
        a.input :course_id, as: :hidden, input_html: { value: params[:course_id] }
      else
        a.input :course_id, as: :search_select, url: admin_courses_path,
                fields: [:course_title, :id], display_name: 'course_title', minimum_input_length: 2, order_by: 'created_at_asc'
      end
      a.input :assessment_title
      a.input :assessment_weight, input_html: { min: 1, max: 100 }
      a.input :final_exam
      if a.object.new_record?
        a.input :created_by, as: :hidden, input_html: { value: current_admin_user.name.full }
        a.input :admin_user_id, as: :hidden, input_html: { value: current_admin_user.id }
      else
        a.input :updated_by, as: :hidden, input_html: { value: current_admin_user.name.full }
        a.input :admin_user_id, as: :hidden, input_html: { value: current_admin_user.id }
      end
    end
  end
  f.actions
end

  

  show title: :assessment_title do
    panel "Assessment Plan Information" do
      attributes_table_for assessment_plan do
        row :assessment_title
        row :assessment_weight
        row :course do |c|
          link_to c.course.course_title, admin_course_path(c.course)
        end
        row :program do |c|
          link_to c.course.program.program_name, admin_program_path(c.course.program)
        end
        row :created_at
        row :updated_at
        row :created_by
        row :updated_by
      end
    end
  end
end
