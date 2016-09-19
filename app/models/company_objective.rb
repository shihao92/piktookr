class CompanyObjective < ApplicationRecord

    belongs_to      :timeframe_log
    belongs_to      :user
    has_many        :company_key_results
    
    has_many        :log_company_objectives

    def self.new_company_objective(objective, user_id)
      status = 0
      log_id = TimeframeLog.current_timeframe_log_id;
      new_company_objective = CompanyObjective.new(
        objective: objective,
        progress: 0.0,
        timeframe_log_id: log_id,
        user_id: user_id
      )
      if new_company_objective.save
        LogCompanyObjective.log_new_company_objective(objective, new_company_objective.id, user_id)
        status = 200
      end

      return status
    end

    def self.update_progress_objective(personal_key_result, objective_id, progress, user_id)
      if CompanyObjective.where(id: objective_id).update_all(progress: progress)
        if user_id != 0
          # Log generated for company objective update
          LogCompanyObjective.log_update_progress_objective(
              personal_key_result, progress, objective_id, user_id
          )          
        end
      end
    end

    def self.rename_company_objective(original_objective, edited_objective, objective_id, user_id)
      status = 0
      if CompanyObjective.where(id: objective_id).update_all(objective: edited_objective)
        LogCompanyObjective.log_rename_company_objective(original_objective, edited_objective, objective_id, user_id)
        status = 200
      end

      return status 
    end

    def self.delete_company_objective(company_objective)
      status = 0
      LogCompanyObjective.where(company_objective_id: company_objective.id).destroy_all()
      if company_objective.destroy
        status = 200
      end

      return status
    end

end
