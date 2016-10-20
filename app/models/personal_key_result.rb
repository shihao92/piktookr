class PersonalKeyResult < ApplicationRecord

    # ---------
    # Relations
    # ---------

    belongs_to      :personal_objective
    has_many        :contributions
    accepts_nested_attributes_for :contributions

    has_many        :log_personal_key_results
    accepts_nested_attributes_for :log_personal_key_results

    # -----------
    # Validations
    # -----------

    validates :key_result, presence: true
    validates :personal_objective_id, presence: true
    validates :progress, :numericality => {:greater_than_or_equal_to => 0.00, :less_than_or_equal_to => 100.00}, on: :update
    validates :is_completed, inclusion: { in: [ true, false ] }


    def self.new_personal_key_result(key_result, objective_id, user_id)
      status = 0
      personal_objective = PersonalObjective.find(objective_id)
      @new_personal_key_result = PersonalKeyResult.new(
        progress: 0.0, 
        key_result: key_result, 
        personal_objective_id: objective_id,
        is_completed: false
      )
      if @new_personal_key_result.save
        LogPersonalKeyResult.log_new_personal_key_result(@new_personal_key_result.id, personal_objective.objective, user_id)    
        cascade_personal_objective("", objective_id, 0)
        status = 200
      else 
        status = 0
      end

      return status
    end

    def self.update_progress_personal_key_result(key_result_id, progress, initial_progress, contribution, user_id)
      status = 0
      progress_difference = progress - initial_progress
      personal_key_result = PersonalKeyResult.find(key_result_id)
      personal_objective_id = (personal_key_result.personal_objective_id).to_i
      # If user_id is 0, system is updating the progress of the OKR that had been newly created.
      # Therefore, no log is required to be generated when update progress.
      if user_id != 0
        if PersonalKeyResult.where(id: key_result_id).update_all(progress: progress)   
          # Log generated for personal key result       
          generated_personal_key_result_log_id = LogPersonalKeyResult.log_update_progress_key_result(key_result_id, progress_difference, user_id) 
          increment_okr_progress(personal_key_result.key_result, progress_difference, personal_key_result.personal_objective_id, user_id)

          # Save new contribution for this personal key result progress increment
          new_contribution = Contribution.new(
            contribution_comment: contribution, 
            personal_key_result_id: key_result_id, 
            log_personal_key_result_id: generated_personal_key_result_log_id
          )
          if new_contribution.save 
            cascade_personal_objective(
              personal_key_result.key_result, 
              personal_objective_id, 
              user_id
            )
            status = 200
          end                
        end
      else
        # For updating the progress of other OKR hierarchy when create operation is done
        # No log required if the new key result is being created
        # Cascade to Personal Objective
        cascade_personal_objective(
          "", 
          personal_key_result.personal_objective_id,  
          user_id
        )
        status = 200
      end

      return status
    end

    # This route is for logging purpose to allow record of progress increment in all 3 OKR Modules
    def self.increment_okr_progress(personal_key_result, progress_contribution_key_result, personal_objective_id, user_id)
      company_key_result_increment = 0.00
      # Personal Objective progress increment
      personal_objective_increment = PersonalObjective.calculate_and_log_progress_increment(personal_key_result, progress_contribution_key_result, personal_objective_id, user_id)
      # Team Key Result progress increment
      okr_team_personal = OkrTeamPersonal.find_by(personal_objective_id: personal_objective_id)
      if okr_team_personal == nil
        okr_company_personal = OkrCompanyPersonal.find_by(personal_objective_id: personal_objective_id)
        company_key_result_increment = CompanyKeyResult.calculate_and_log_progress_increment(personal_key_result, personal_objective_increment, okr_company_personal.company_key_result_id, user_id)
        # Company Objective progress increment
        company_key_result = CompanyKeyResult.find(okr_company_personal.company_key_result_id)
      else
        team_key_result_increment = TeamKeyResult.calculate_and_log_progress_increment(personal_key_result, personal_objective_increment, okr_team_personal.team_key_result_id, user_id)
        # Team Objective progress increment
        team_key_result = TeamKeyResult.find(okr_team_personal.team_key_result_id)
        team_objective_increment = TeamObjective.calculate_and_log_progress_increment(personal_key_result, team_key_result_increment, team_key_result.team_objective_id, user_id)
        # Company Key Result progress increment
        okr_company_team = OkrCompanyTeam.find_by(team_objective_id: team_key_result.team_objective_id)
        company_key_result_increment = CompanyKeyResult.calculate_and_log_progress_increment(personal_key_result, team_objective_increment, okr_company_team.company_key_result_id, user_id)
        # Company Objective progress increment
        company_key_result = CompanyKeyResult.find(okr_company_team.company_key_result_id)
      end
      CompanyObjective.calculate_and_log_progress_increment(personal_key_result, company_key_result_increment, company_key_result.company_objective_id, user_id)
    end

    def self.update_status_personal_key_result(key_result_id, objective_id, completed_flag, user_id)
      status = 0
      if PersonalKeyResult.where(id: key_result_id).update_all(is_completed: completed_flag)
        if completed_flag == "true"
          # Only completed key result will be logged
          LogPersonalKeyResult.log_update_status_key_result(key_result_id, user_id)
        else
          personal_key_result = PersonalKeyResult.find(key_result_id)
          # Remove all marked completed log
          LogPersonalKeyResult.remove_log_completed_key_result(key_result_id)
        end
        status = 200
      end

      return status
    end

    def self.rename_personal_key_result(original_key_result, edited_key_result, key_result_id, user_id)
      status = 0
      if PersonalKeyResult.where(id: key_result_id).update_all(key_result: edited_key_result)
        LogPersonalKeyResult.log_rename_personal_key_result(original_key_result, edited_key_result, key_result_id, user_id)
        status = 200
      end
      return status
    end

    def self.delete_personal_key_result(personal_key_result)
      status = 0
      Contribution.where(personal_key_result_id: personal_key_result.id).destroy_all()
      LogPersonalObjective.log_delete_personal_key_result(personal_key_result.id)
      LogPersonalKeyResult.where(personal_key_result_id: personal_key_result.id).destroy_all()
      if personal_key_result.destroy
        cascade_personal_objective("", personal_key_result.personal_objective_id, 0)
        status = 200
      end
      return status
    end

    def self.cascade_personal_objective(key_result, objective_id, user_id)
      status = 0
      # Cascade to Personal Objective
      personal_key_results = PersonalKeyResult.where(personal_objective_id: objective_id)
      total_progress = 0.00
      item_count = 0
      personal_key_results.each do |item|
        total_progress = total_progress + item.progress
        item_count = item_count + 1 
      end
      # If all the personal key result is being marked as completed
      if item_count == 0 
        total_progress = 0.00
        item_count = 1
      end
      progress_contribution = OkrCalculation.calculate_progress_contribution(total_progress, item_count)
      PersonalObjective.update_progress_objective(
        key_result,
        objective_id, 
        progress_contribution, 
        user_id
      )
      status = 200

      return status
    end

    def self.update_due_date(key_result_id, due_date)
      status = 0
      if PersonalKeyResult.where(id: key_result_id).update_all(due_date: due_date)
        status = 200
      end
      return status
    end

    def self.retrieve_created_date(key_result_id)
      personal_key_result = PersonalKeyResult.find(key_result_id)
      return personal_key_result.created_at
    end

    def self.search_key_result(keyword, timeframe_log_id)
      personal_key_result = PersonalKeyResult.joins("inner join personal_objectives on personal_objectives.id = personal_key_results.personal_objective_id")
                                             .where("personal_objectives.timeframe_log_id = ? and key_result like ?", timeframe_log_id, "%#{keyword}%")
      return personal_key_result
    end

end
