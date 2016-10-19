class CompanyKeyResult < ApplicationRecord

    # ---------
    # Relations
    # ---------

    belongs_to   :company_objective
    belongs_to   :user

    has_many     :okr_company_teams
    has_many     :team_objectives, :through => :okr_company_teams

    has_many     :okr_company_personals
    has_many     :personal_objectives, :through => :okr_company_personals

    has_many     :log_company_key_results

    # -----------
    # Validations
    # -----------

    validates   :key_result, presence: true, length: { minimum: 2 }, uniqueness: true
    validates   :progress, presence: true, :numericality => {:greater_than_or_equal_to => 0, :less_than_or_equal_to => 100}
    validates   :company_objective_id, presence: true
    validates   :user_id, presence: true


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
          cascade_company_objective(personal_key_result, company_key_result.company_objective_id, user_id)
        else
          cascade_company_objective("", company_key_result.company_objective_id, user_id)
        end
      end
    end

    def self.calculate_and_log_progress_increment(personal_key_result, progress, company_key_result_id, user_id)
      # Find out how many team objective is linked with this company key result
      okr_company_teams = OkrCompanyTeam.where(company_key_result_id: company_key_result_id)
      progress_increment = OkrCalculation.calculate_progress_contribution(progress, okr_company_teams.count)
      log_content = LogCompanyKeyResult.log_update_progress_key_result(personal_key_result, company_key_result_id, progress_increment, user_id)
      return progress_increment
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
        progress_contribution = OkrCalculation.calculate_progress_contribution(total_progress, company_key_results.count)
      end
      CompanyObjective.update_progress_objective(
        personal_key_result,
        objective_id,
        progress_contribution, 
        user_id
      )
    end

    def self.update_due_date(key_result_id, due_date)
      status = 0
      if CompanyKeyResult.where(id: key_result_id).update_all(due_date: due_date)
        status = 200
      end
      return status
    end

    def self.retrieve_created_date(key_result_id)
      company_key_result = CompanyKeyResult.find(key_result_id)
      return company_key_result.created_at
    end

    def self.search_key_result(keyword, timeframe_log_id)
      company_key_result = CompanyKeyResult.joins("inner join company_objectives on company_objectives.id = company_key_results.company_objective_id")
                                           .where("company_objectives.timeframe_log_id = ? and key_result like ?", timeframe_log_id, "%#{keyword}%")
      return company_key_result
    end

end
