class TeamObjective < ApplicationRecord

    has_many           :okr_company_teams
    has_many           :company_key_results, :through => :okr_company_teams
    belongs_to         :okr_team
    has_many           :team_key_results

    belongs_to         :timeframe_log
    belongs_to         :user


    has_many           :log_team_objectives

    def self.new_team_objective(objective, company_key_result_id, user_id, team_id)
      status = 0
      log_id = TimeframeLog.current_timeframe_log_id
      new_team_objective = TeamObjective.new(
        objective: objective,
        progress: 0.0, 
        timeframe_log_id: log_id, 
        okr_team_id: team_id,
        user_id: user_id
      )
      company_key_result = CompanyKeyResult.find(company_key_result_id)
      if new_team_objective.save
        OkrCompanyTeam.create!(team_objective_id: new_team_objective.id,company_key_result_id: company_key_result_id)
        LogTeamObjective.log_new_team_objective(objective, new_team_objective.id, company_key_result.key_result, user_id)
        cascade_company_key_result("", company_key_result_id, 0)
        status = 200
      end

      return status
    end

    def self.update_progress_objective(personal_key_result, objective_id, progress, user_id)
      # If user_id is 0, system is updating the progress of the OKR that had been newly created.
      # Therefore, no log is required to be generated when update progress.
      okr_company_team = OkrCompanyTeam.find_by(team_objective_id: objective_id)
      if TeamObjective.where(id: objective_id).update_all(progress: progress)
        if user_id != 0
          # Log generated for team objective update
          LogTeamObjective.log_update_progress_objective(
              personal_key_result, progress, objective_id, user_id
          )
          cascade_company_key_result(personal_key_result, okr_company_team.company_key_result_id, user_id)      
        else
          cascade_company_key_result("", okr_company_team.company_key_result_id, user_id)
        end
      end
    end

    def self.rename_team_objective(original_objective, edited_objective, objective_id, user_id)
      status = 0
      if TeamObjective.where(id: objective_id).update_all(objective: edited_objective)
        LogTeamObjective.log_rename_team_objective(original_objective, edited_objective, objective_id, user_id)
        status = 200
      end

      return status
    end

    def self.delete_team_objective(team_objective)
      status = 0
      okr_company_team = OkrCompanyTeam.find_by(team_objective_id: team_objective.id)
      company_key_result_id = okr_company_team.company_key_result_id

      OkrCompanyTeam.where(team_objective_id: team_objective.id).destroy_all
      LogTeamObjective.where(team_objective_id: team_objective.id).destroy_all
      team_key_results = TeamKeyResult.where(team_objective_id: team_objective.id)
      team_key_results.each do |item|
        LogTeamKeyResult.where(team_key_result_id: item.team_key_result_id).destroy_all
        TeamKeyResult.where(id: item.id).destroy_all
      end
      TeamKeyResult.where(team_objective_id: team_objective.id).destroy_all
      if team_objective.destroy
        cascade_company_key_result("", company_key_result_id, 0)
        status = 200
      end

      return status
    end

    def self.cascade_company_key_result(personal_key_result, key_result_id, user_id)
      # Find out the number of team objectives linked to this company key result
      team_objectives = OkrCompanyTeam.where(company_key_result_id: key_result_id)
      total_progress = 0.00 
      if team_objectives.count == 0
        progress_contribution = 0
      else
        team_objectives.each do |item|
          team_objective = TeamObjective.find(item.team_objective_id)
          total_progress = total_progress + team_objective.progress
        end
        progress_contribution = calculate_progress_contribution(total_progress, team_objectives.count)  
      end
      CompanyKeyResult.update_progress_key_result(
        personal_key_result,
        key_result_id,
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
