class PersonalObjective < ApplicationRecord

    # ---------
    # Relations
    # ---------

    has_many           :okr_team_personals
    has_many           :team_key_results, :through => :okr_team_personals

    has_many           :okr_company_personals
    has_many           :company_key_results, :through => :okr_company_personals
    
    belongs_to         :timeframe_log
    belongs_to         :user

    has_many           :personal_key_results

    has_many           :log_personal_objectives

    # -----------
    # Validations
    # -----------

    validates :objective, presence: true, length: { minimum: 5 }
    validates :progress, :numericality => {:greater_than_or_equal_to => 0, :less_than_or_equal_to => 100}
    validates :timeframe_log_id, presence: true, :numericality => { only_integer: true }
    validates :user_id, presence: true


    def self.new_personal_objective(objective, team_key_result_id, user_id)
      status = 0
      okr_user_timeframe = OkrUserTimeframe.find_by(user_id: user_id)
      log_id = okr_user_timeframe.timeframe_log_id

      new_personal_objective = PersonalObjective.new(
        objective: objective, 
        progress: 0.0, 
        timeframe_log_id: log_id, 
        user_id: user_id
      )

      if new_personal_objective.save
        status = 200
        OkrTeamPersonal.create!(team_key_result_id: team_key_result_id, personal_objective_id: new_personal_objective.id)
        team_key_result = TeamKeyResult.find(team_key_result_id)
        LogPersonalObjective.log_new_personal_objective(objective, new_personal_objective.id, team_key_result.key_result, user_id)
        cascade_team_key_result("", team_key_result_id, 0)
      end

      return status
    end

    def self.new_personal_objective_linked_company(objective, company_key_result_id, user_id)
      status = 0
      okr_user_timeframe = OkrUserTimeframe.find_by(user_id: user_id)
      log_id = okr_user_timeframe.timeframe_log_id

      new_personal_objective = PersonalObjective.new(
        objective: objective, 
        progress: 0.0, 
        timeframe_log_id: log_id, 
        user_id: user_id
      )

      if new_personal_objective.save
        status = 200
        OkrCompanyPersonal.create!(company_key_result_id: company_key_result_id, personal_objective_id: new_personal_objective.id)
        company_key_result = CompanyKeyResult.find(company_key_result_id)
        LogPersonalObjective.log_new_personal_objective(objective, new_personal_objective.id, company_key_result.key_result, user_id)
        cascade_company_key_result("", company_key_result_id, 0)
      end

      return status
    end

    def self.update_progress_objective(personal_key_result, objective_id, progress, user_id)
      # If user_id is 0, system is updating the progress of the OKR that had been newly created.
      # Therefore, no log is required to be generated when update progress.
      okr_team_personal = OkrTeamPersonal.find_by(personal_objective_id: objective_id)
      if okr_team_personal == nil
        okr_company_personal = OkrCompanyPersonal.find_by(personal_objective_id: objective_id)
        if PersonalObjective.where(id: objective_id).update_all(progress: progress)
          if user_id != 0            
            cascade_company_key_result(personal_key_result, okr_company_personal.company_key_result_id, user_id)
          else
            cascade_company_key_result("", okr_company_personal.company_key_result_id, user_id)
          end
        end
      else
        if PersonalObjective.where(id: objective_id).update_all(progress: progress)
          if user_id != 0            
            cascade_team_key_result(personal_key_result, okr_team_personal.team_key_result_id, user_id)
          else
            cascade_team_key_result("", okr_team_personal.team_key_result_id, user_id)
          end
        end
      end
    end

    def self.calculate_and_log_progress_increment(personal_key_result, progress, objective_id, user_id)
      # Find out how many personal key result is linked with this personal objective
      personal_objectives = PersonalKeyResult.where(personal_objective_id: objective_id)
      progress_increment = OkrCalculation.calculate_progress_contribution(progress, personal_objectives.count)
      log_content = LogPersonalObjective.log_update_progress_objective(personal_key_result, progress_increment, objective_id, user_id)
      return progress_increment
    end

    def self.rename_personal_objective(original_objective, edited_objective, objective_id, user_id)
      status = 0
      if PersonalObjective.where(id: objective_id).update_all(objective: edited_objective)
        LogPersonalObjective.log_rename_personal_objective(original_objective, edited_objective, objective_id, user_id)
        status = 200
      end
      return status
    end

    def self.remove_related_data(personal_objective)
      LogPersonalObjective.where(personal_objective_id: personal_objective.id).destroy_all()
      PersonalKeyResult.where(personal_objective_id: personal_objective.id).each do |item|
        LogPersonalKeyResult.where(personal_key_result_id: item.id).destroy_all()
      end
      PersonalKeyResult.where(personal_objective_id: personal_objective.id).destroy_all()
    end

    def self.delete_personal_objective(personal_objective)
      status = 0
      okr_team_personal = OkrTeamPersonal.find_by(personal_objective_id: personal_objective.id)
      if okr_team_personal != nil
        team_key_result_id = okr_team_personal.team_key_result_id
        OkrTeamPersonal.where(personal_objective_id: personal_objective.id).destroy_all()
        remove_related_data(personal_objective)
        if personal_objective.destroy
          cascade_team_key_result("", team_key_result_id, 0)
          status = 200
        else
          status = 0
        end
      else
        okr_company_personal = OkrCompanyPersonal.find_by(personal_objective_id: personal_objective.id)
        company_key_result_id = okr_company_personal.company_key_result_id
        OkrCompanyPersonal.where(personal_objective_id: personal_objective.id).destroy_all()
        remove_related_data(personal_objective)
        if personal_objective.destroy
          cascade_company_key_result("", company_key_result_id, 0)
          status = 200
        else
          status = 0
        end
      end

      return status
    end

    def self.cascade_team_key_result(personal_key_result, key_result_id, user_id)
      # Find out the number of personal objectives linked to this team key result 
      personal_objectives = OkrTeamPersonal.where(team_key_result_id: key_result_id)
      total_progress = 0.00
      if personal_objectives.count == 0
        progress_contribution = 0.00
      else
        personal_objectives.each do |item|
          personal_objective = PersonalObjective.find(item.personal_objective_id)
          total_progress = total_progress + personal_objective.progress
        end
        progress_contribution = OkrCalculation.calculate_progress_contribution(total_progress, personal_objectives.count)
      end
      TeamKeyResult.update_progress_key_result(
        personal_key_result, 
        key_result_id, 
        progress_contribution, 
        user_id
      )
    end

    def self.cascade_company_key_result(personal_key_result, key_result_id, user_id)
      company_personal_objectives = OkrCompanyPersonal.where(company_key_result_id: key_result_id)
      company_team_objectives = OkrCompanyTeam.where(company_key_result_id: key_result_id)

      total_progress = 0.00

      company_personal_objectives.each do |item|
        personal_objective = PersonalObjective.find(item.personal_objective_id)
        total_progress = total_progress + personal_objective.progress
      end

      company_team_objectives.each do |item|
        team_objective = TeamObjective.find(item.team_objective_id)
        total_progress = total_progress + team_objective.progress
      end

      company_key_result = CompanyKeyResult.find(key_result_id)
      linked_objectives_count = company_personal_objectives.count + company_team_objectives.count
      if linked_objectives_count == 0
        linked_objectives_count = 1
      end
      progress_contribution = total_progress / linked_objectives_count

      CompanyKeyResult.update_progress_key_result(
        personal_key_result,
        key_result_id,
        progress_contribution,
        user_id
      )
    end

    def self.retrieve_created_date(objective_id)
      personal_objective = PersonalObjective.find(objective_id)
      return personal_objective.created_at
    end

    def self.search_objective(keyword, timeframe_log_id)
      personal_objective = PersonalObjective.select("id, objective").where("objective like ? and timeframe_log_id = ?", "%#{keyword}%", timeframe_log_id)
      return personal_objective
    end

end
