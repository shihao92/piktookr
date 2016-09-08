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
      @user = User.find(current_user.id)
      
      @okr_user_role = OkrUserRole.where(user_id: current_user.id)
      @role = OkrRole.where(id: @okr_user_role[0].okr_role_id) 
      @team_ids = OkrUserTeam.where(user_id: current_user.id) 
      
      @temp_team_objective = []
      @temp_team_key_result = []
      @team_ids.each do |item|
        @team_objectives = TeamObjective.where(okr_team_id: item.okr_team_id).all.map{|obj| [obj.objective, obj.id] }
        @temp_team_objective.push(@team_objectives)
      end

      @temp_team_objective.each_with_index do |item,index|
        @count = 0
        while(@count < item.count)
          @team_key_results = TeamKeyResult.where(team_objective_id: item[@count][1]).all.map{|kr| [kr.key_result, kr.id]}
          @team_key_results.each do |element|
            @temp_team_key_result.push(element)
          end
          @count = @count + 1
        end      
      end

      # @team_key_results = TeamKeyResult.where(team_objective_id: @team_objectives)
      
      @temp_team_objective = []
      @temp_team_key_result = []
      @team_ids.each do |item|
        @team_objectives = TeamObjective.where(okr_team_id: item.okr_team_id).all.map{|obj| [obj.objective, obj.id] }
        @temp_team_objective.push(@team_objectives)
      end

      @temp_team_objective.each_with_index do |item,index|
        @count = 0
        while(@count < item.count)
          @team_key_results = TeamKeyResult.where(team_objective_id: item[@count][1]).all.map{|kr| [kr.key_result, kr.id]}
          @team_key_results.each do |element|
            @temp_team_key_result.push(element)
          end
          @count = @count + 1
        end      
      end

      @personal_objective = PersonalObjective.where(user_id: current_user.id) 
      
      @completed_objective = 0 
      if(@personal_objective.count != 0) 
        @progress_portion = 100 / @personal_objective.count 
        @total_progress = 0 
        @temp_date = [] 
        @personal_objective.each do |item| 
          @temp_progress = (item.progress/100) * @progress_portion 
          @total_progress = @total_progress + @temp_progress 
          # To check whether there is any completed objective  
          if(item.progress == 100.00) 
            @completed_objective = @completed_objective + 1 
          end 
          # To check which is the latest updated date 
          @temp_date << item.updated_at 
        end 
        @date_max = @temp_date.max 
        @date_difference = (Time.now - @date_max) / 86400 
      end 
      
      @current_date = Time.now.strftime("%Y-%m-%d") 
      @timeframe_logs = TimeframeLog.where("start_date <= '" + @current_date + "'") 
      @current_timeframe_log = TimeframeLog.where("(start_date,end_date) overlaps ('" + @current_date + "'::DATE,'" + @current_date + "'::DATE)") 
      @remaining_quarter_days = @current_timeframe_log[0].end_date - Time.now.to_date 

      render "app/dashboard_v2"
    end
end
