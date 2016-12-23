class TeamKeyResult < ApplicationRecord

    # ---------
    # Relations
    # ---------

    belongs_to      :team_objective
    belongs_to      :user

    has_many        :okr_team_personals
    has_many        :personal_objectives, :through => :okr_team_personals

    has_many        :log_team_key_results

    # -----------
    # Validations
    # -----------

    validates   :key_result, presence: true, length: { minimum: 5 }
    validates   :progress, :numericality => {:greater_than_or_equal_to => 0, :less_than_or_equal_to => 100}
    validates   :team_objective_id, presence: true, :numericality => { only_integer: true }
    validates   :user_id, presence: true


    def self.new_team_key_result(key_result, team_objective_id, user_id)
      status = 0
      team_objective = TeamObjective.find(team_objective_id)
      current_quarter_end_date = TimeframeLog.current_quarter_end_date
      new_team_key_result = TeamKeyResult.new(
        progress: 0.0, 
        key_result: key_result , 
        team_objective_id: team_objective_id, 
        user_id: user_id,
        due_date: current_quarter_end_date
      )
      if new_team_key_result.save
        LogTeamKeyResult.log_new_team_key_result(new_team_key_result.id, team_objective.objective, user_id)
        cascade_team_objective("", team_objective_id, 0) 
        status = 200
      end

      return status
    end

    def self.update_progress_key_result(personal_key_result, key_result_id, progress, user_id)
      # If user_id is 0, system is updating the progress of the OKR that had been newly created.
      # Therefore, no log is required to be generated when update progress.
      team_key_result = TeamKeyResult.find(key_result_id)
      if TeamKeyResult.where(id: key_result_id).update_all(progress: progress)
        if user_id != 0
          cascade_team_objective(personal_key_result, team_key_result.team_objective_id, user_id)                
        else
          cascade_team_objective("", team_key_result.team_objective_id, user_id) 
        end
      end
    end

    def self.calculate_and_log_progress_increment(personal_key_result, personal_key_result_id, progress, team_key_result_id, user_id)
      # Find out how many personal objective is linked with this team key result
      okr_team_personals = OkrTeamPersonal.where(team_key_result_id: team_key_result_id)
      progress_increment = OkrCalculation.calculate_progress_contribution(progress, okr_team_personals.count)
      log_content = LogTeamKeyResult.log_update_progress_key_result(personal_key_result, personal_key_result_id, team_key_result_id, progress_increment, user_id)
      return progress_increment
    end

    def self.rename_team_key_result(original_key_result, edited_key_result, key_result_id, user_id)
      status = 0
      if TeamKeyResult.where(id: key_result_id).update_all(key_result: edited_key_result)
        LogTeamKeyResult.log_rename_team_key_result(original_key_result, edited_key_result, key_result_id, user_id)
        status = 200
      end

      return status
    end

    def self.delete_team_key_result(team_key_result)
      status = 0
      team_objective = TeamObjective.find(team_key_result.team_objective_id)     
      LogTeamKeyResult.where(team_key_result_id: team_key_result.id).destroy_all()
      if team_key_result.destroy
        LogTeamObjective.log_delete_team_key_result(team_key_result.key_result, team_key_result.team_objective_id, team_key_result.user_id)
        cascade_team_objective("", team_key_result.team_objective_id, 0)
        status = 200
      end

      return status
    end

    def self.cascade_team_objective(personal_key_result, objective_id, user_id)
      # Find out the number of team key results linked to this team objective
      team_key_results = TeamKeyResult.where(team_objective_id: objective_id)
      total_progress = 0.00
      if team_key_results.count == 0
        progress_contribution = 0.00
      else
        team_key_results.each do |item|
          total_progress = total_progress + item.progress
        end
        progress_contribution = OkrCalculation.calculate_progress_contribution(total_progress, team_key_results.count)
      end         
      TeamObjective.update_progress_objective(
        personal_key_result,
        objective_id,
        progress_contribution, 
        user_id
      )
    end

    def self.update_due_date(key_result_id, due_date)
      status = 0
      if TeamKeyResult.where(id: key_result_id).update_all(due_date: due_date)
        status = 200
      end
      return status
    end

    def self.retrieve_created_date(key_result_id)
      team_key_result = TeamKeyResult.find(key_result_id)
      return team_key_result.created_at
    end

    def self.search_key_result(keyword, timeframe_log_id)
      team_key_result = TeamKeyResult.select("team_key_results.id, team_key_results.key_result, team_objectives.okr_team_id").joins("inner join team_objectives on team_objectives.id = team_key_results.team_objective_id")
                                           .where("team_objectives.timeframe_log_id = ? and key_result like ?", timeframe_log_id, "%#{keyword}%")
      return team_key_result
    end

end
