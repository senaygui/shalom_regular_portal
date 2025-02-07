namespace :update_assessment_approvals do
    desc "Update assessments with approver information"
  
    task update_approvals: :environment do
      puts "Starting update for instructor approvals..."
  
      Assessment.where(status: 1).find_each do |assessment|
        puts "Processing assessment ID #{assessment.id} for instructor approval..."
        approval_log = ApprovalLog.find_by(assessment_id: assessment.id, approval_type: 'instructor')
        if approval_log
          puts "Found approval log for instructor approval with admin_user_id #{approval_log.admin_user_id}"
          assessment.update(approved_by_instructor_id: approval_log.admin_user_id)
          puts "Updated assessment ID #{assessment.id} with instructor ID #{approval_log.admin_user_id}"
        else
          puts "No approval log found for instructor approval for assessment ID #{assessment.id}"
        end
      end
  
      puts "Starting update for department head approvals..."
  
      Assessment.where(status: 2).find_each do |assessment|
        puts "Processing assessment ID #{assessment.id} for department head approval..."
        approval_log = ApprovalLog.find_by(assessment_id: assessment.id, approval_type: 'department_head')
        if approval_log
          puts "Found approval log for department head approval with admin_user_id #{approval_log.admin_user_id}"
          assessment.update(approved_by_head_id: approval_log.admin_user_id)
          puts "Updated assessment ID #{assessment.id} with department head ID #{approval_log.admin_user_id}"
        else
          puts "No approval log found for department head approval for assessment ID #{assessment.id}"
        end
      end
  
      puts "Starting update for dean approvals..."
  
      Assessment.where(status: 5).find_each do |assessment|
        puts "Processing assessment ID #{assessment.id} for dean approval..."
        approval_log = ApprovalLog.find_by(assessment_id: assessment.id, approval_type: 'dean')
        if approval_log
          puts "Found approval log for dean approval with admin_user_id #{approval_log.admin_user_id}"
          assessment.update(approved_by_dean_id: approval_log.admin_user_id)
          puts "Updated assessment ID #{assessment.id} with dean ID #{approval_log.admin_user_id}"
        else
          puts "No approval log found for dean approval for assessment ID #{assessment.id}"
        end
      end
  
      puts "Assessments updated successfully."
    end
  end
  