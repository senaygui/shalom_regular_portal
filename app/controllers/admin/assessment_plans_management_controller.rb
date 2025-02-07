# app/controllers/admin/assessment_plans_management_controller.rb
class Admin::AssessmentPlansManagementController < ApplicationController
    def new
      @assessment_plan = AssessmentPlan.new
    end
  
    def create
      @assessment_plan = AssessmentPlan.new(assessment_plan_params)
  
      if @assessment_plan.save
        redirect_to admin_assessment_plans_path, notice: 'Assessment plan was successfully created.'
      else
        render :new
      end
    end
  
    def create_multiple
      assessment_plans_params = params.require(:assessment_plans).map do |index, plan_params|
        plan_params.permit(:assessment_title, :assessment_weight, :final_exam)
      end
  
      assessment_plans_params.each do |plan_params|
        AssessmentPlan.create!(plan_params)
      end
  
      redirect_to admin_assessment_plans_path, notice: 'Assessment plans created successfully.'
    end
  
    private
  
    def assessment_plan_params
      params.require(:assessment_plan).permit(:assessment_title, :assessment_weight, :final_exam)
    end
  end
  