class AssessmentResultsController < ApplicationController
    def create
      @assessment = Assessment.find(params[:assessment_id])
      @assessment_result = @assessment.assessment_results.build(assessment_result_params)
  
      if @assessment_result.save
        redirect_to @assessment.assessment_plan, notice: 'Assessment result was successfully created.'
      else
        render 'assessment_plans/show'
      end
    end
  
    private
  
    def assessment_result_params
      params.require(:assessment_result).permit(:score)
    end
  end
  