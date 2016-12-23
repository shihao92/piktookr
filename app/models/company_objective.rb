class CompanyObjective < ApplicationRecord

    # ---------
    # Relations
    # ---------

    belongs_to      :timeframe_log
    belongs_to      :user
    has_many        :company_key_results
    
    has_many        :log_company_objectives

    # -----------
    # Validations
    # -----------

    validates   :objective, presence: true, length: { minimum: 5 }, uniqueness: true
    validates   :progress, presence: true, :numericality => {:greater_than_or_equal_to => 0, :less_than_or_equal_to => 100}
    validates   :timeframe_log_id, presence: true
    validates   :user_id, presence: true


    def self.new_company_objective(objective, user_id)
      status = 0
      okr_user_timeframe = OkrUserTimeframe.find_by(user_id: user_id)
      log_id = okr_user_timeframe.timeframe_log_id
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
      CompanyObjective.where(id: objective_id).update_all(progress: progress)
    end

    def self.calculate_and_log_progress_increment(personal_key_result, personal_key_result_id, progress, company_objective_id, user_id)
      # Find out how many company objective is linked with this company key result
      company_key_results = CompanyKeyResult.where(company_objective_id: company_objective_id)
      progress_increment = OkrCalculation.calculate_progress_contribution(progress, company_key_results.count)
      LogCompanyObjective.log_update_progress_objective(personal_key_result, personal_key_result_id, progress_increment, company_objective_id, user_id)
    end

    def self.rename_company_objective(original_objective, edited_objective, objective_id, user_id)
      status = 0
      if CompanyObjective.where(id: objective_id).update_all(objective: edited_objective)
        LogCompanyObjective.log_rename_company_objective(original_objective, edited_objective, objective_id, user_id)
        status = 200
      end

      return status 
    end

    def self.delete_company_objective(company_objective_id)
      status = 0
      LogCompanyObjective.where(company_objective_id: company_objective_id).destroy_all()
      company_objective = CompanyObjective.find(company_objective_id)
      if company_objective.destroy
        status = 200
      end

      return status
    end

    def self.retrieve_created_date(objective_id)
      company_objective = CompanyObjective.find(objective_id)
      return company_objective.created_at
    end 

    def self.search_objective(keyword, timeframe_log_id)
      company_objective = CompanyObjective.select("id, objective").where("objective like ? and timeframe_log_id = ?", "%#{keyword}%", timeframe_log_id)
      return company_objective
    end

end
