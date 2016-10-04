class AppController < ApplicationController
    def resource_name
      :user
    end
  
    def resource
      @resource ||= User.new
    end
  
    def devise_mapping
      @devise_mapping ||= Devise.mappings[:user]
    end

    # After login successfully, check role
    def check_role
      @role_id = OkrUserRole.find_by user_id:(current_user.id)
      @role = OkrRole.find_by id:(@role_id.okr_role_id)
      render json: @role, status: :ok
    end

    def dashboard_v2   
      pages_initialization

      team_ids = OkrUserTeam.where(user_id: current_user.id) 
      temp_team_objective = []

      @personal_objective = PersonalObjective.where(user_id: current_user.id, timeframe_log_id: @@system_timeframe_log_id).order(updated_at: :DESC)
      @completed_objective = 0 
      @total_progress = 0
      @temp_team_key_result = []                  
      
      personal_objective_count = @personal_objective.count
      if(personal_objective_count != 0) 
        progress_portion = 100 / personal_objective_count  
        temp_date = [] 
        @personal_objective.each do |item| 
          @total_progress = @total_progress + item.progress 
          # To check whether there is any completed objective  
          if(item.progress == 100.00) 
            @completed_objective = @completed_objective + 1 
          end 
          # To check which is the latest updated date 
          temp_date << item.updated_at 
        end 
        @total_progress = @total_progress / personal_objective_count 
        @date_difference = (Time.now - @user.updated_at) / 86400 
      end 
      
      team_ids.each do |item|
        team_objectives = TeamObjective.where(okr_team_id: item.okr_team_id).map{|obj| [obj.objective, obj.id] }
        temp_team_objective.push(team_objectives)
      end

      temp_team_objective.each do |item|
        count = 0
        while(count < item.count)
          team_key_results = TeamKeyResult.where(team_objective_id: item[count][1]).map{|kr| [kr.key_result, kr.id]}
          team_key_results.each do |element|
            @temp_team_key_result.push(element)
          end
          count = count + 1
        end      
      end

      render "app/dashboard_v2"
    end
    
end
