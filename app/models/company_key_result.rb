class CompanyKeyResult < ApplicationRecord

    belongs_to   :company_objective
    belongs_to   :user

    has_many     :okr_company_teams
    has_many     :team_objectives, :through => :okr_company_teams

    has_many     :log_company_key_results

    def self.new_company_key_result(key_result, company_objective_id, user_id)
      status = 0
      company_objective = CompanyObjective.find(company_objective_id)
      new_company_key_result = CompanyKeyResult.new(
        key_result: key_result,
        progress: 0.0,
        company_objective_id: company_objective_id,
        user_id: user_id
      )
      if new_company_key_result.save
        LogCompanyKeyResult.log_new_company_key_result(new_company_key_result.id, company_objective.objective, user_id)
        cascade_company_objective("", company_objective_id, 0)
        status = 200
      end

      return status
    end

    def self.update_progress_key_result(personal_key_result, key_result_id, progress, user_id)
      company_key_result = CompanyKeyResult.find(key_result_id)
      if CompanyKeyResult.where(id: key_result_id).update_all(progress: progress)
        if user_id != 0    
          # Log generated for company key result progress update
          LogCompanyKeyResult.log_update_progress_key_result(personal_key_result, key_result_id, progress, user_id)
          cascade_company_objective(personal_key_result, company_key_result.company_objective_id, user_id)
        else
          cascade_company_objective("", company_key_result.company_objective_id, user_id)
        end
      end
    end

    def self.rename_company_key_result(original_key_result, edited_key_result, key_result_id, user_id)
      status = 0
      if CompanyKeyResult.where(id: key_result_id).update_all(key_result: edited_key_result)
        LogCompanyKeyResult.log_rename_company_key_result(original_key_result, edited_key_result, key_result_id, user_id)
        status = 200
      end

      return status
    end

    def self.delete_company_key_result(company_key_result)
      status = 0
      company_objective = CompanyObjective.find(company_key_result.company_objective_id)     
      LogCompanyKeyResult.where(company_key_result_id: company_key_result.id).destroy_all()
      if company_key_result.destroy
        LogCompanyObjective.log_delete_company_key_result(company_key_result.key_result, company_key_result.company_objective_id, company_key_result.user_id)
        cascade_company_objective("", company_key_result.company_objective_id, 0)
        status = 200
      end

      return status
    end

    def self.cascade_company_objective(personal_key_result, objective_id, user_id)
      # Cascade to company objective
      # Find out the number of company key results that linked to this company objective
      company_key_results = CompanyKeyResult.where(company_objective_id: objective_id)
      total_progress = 0.00
      if company_key_results.count == 0
        progress_contribution = 0.00
      else
        company_key_results.each do |item|
          total_progress = total_progress + item.progress
        end
        progress_contribution = calculate_progress_contribution(total_progress, company_key_results.count)
      end
      CompanyObjective.update_progress_objective(
        personal_key_result,
        objective_id,
        progress_contribution, 
        user_id
      )
    end

    def self.calculate_progress_contribution(progress, count) 
      progress_contribution = progress / count
      progress_contribution = progress_contribution.round(2)
      return progress_contribution
    end

end
