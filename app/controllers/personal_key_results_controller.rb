# Date : 5 August 2016
# Completed module : Create, Read, Update and Delete feature for OKR Module
# Date : 1 September 2016
# Completed module : Log feature for OKR Module

class PersonalKeyResultsController < ApplicationController
  before_action :set_personal_key_result, only: [:show, :edit, :update, :destroy]

  # Declarations for public variable
  @@progress_before_update = 0.00;

  # GET /personal_key_results
  # GET /personal_key_results.json
  def index

    # Access to own personal key result only
    # @personal_objectives = PersonalObjective.all.where(user_id: current_user.id)
    # @personal_key_results = PersonalKeyResult.all.where(personal_objective_id: @personal_objectives.ids)

    # General access to all the personal key results
    @personal_key_results = PersonalKeyResult.all

  end

  # GET /personal_key_results/1
  # GET /personal_key_results/1.json
  def show
  end

  # GET /personal_key_results/new
  def new
    @personal_key_result = PersonalKeyResult.new
    @contribution = @personal_key_result.contributions.build
    @log_personal_key_result = @personal_key_result.contributions.build
  end

  # GET /personal_key_results/1/edit
  def edit
    @contribution = @personal_key_result.contributions.build
    @@progress_before_update = @personal_key_result.progress
  end

  # POST /personal_key_results
  # POST /personal_key_results.json
  def create
    @personal_objective = PersonalObjective.where(id: personal_key_result_params[:personal_objective_id])

    @log_content = 'Created <span class="bold">' + params[:personal_key_result][:key_result] + '</span> and aligned with <span class="bold">' + @personal_objective[0].objective + '</span>'

    @personal_key_result = PersonalKeyResult.new(personal_key_result_params.merge(progress: 0.0, personal_objective_id: personal_key_result_params[:personal_objective_id]))
    respond_to do |format|
      if @personal_key_result.save  
        @log_personal_key_result = LogPersonalKeyResult.new(log_content: @log_content, personal_key_result_id:@personal_key_result.id, user_id: current_user.id)     
        @log_personal_key_result.save
        # Activate the cascade OKR update functions
        update_okr_modules(@personal_key_result.personal_objective_id,@personal_key_result.id,@personal_key_result.progress)

        format.html { redirect_to @personal_key_result, notice: 'Personal key result was successfully created.' }
        format.json { render :show, status: :created, location: @personal_key_result }
      else
        format.html { render :new }
        format.json { render json: @personal_key_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /personal_key_results/1
  # PATCH/PUT /personal_key_results/1.json
  def update
    respond_to do |format|
      # Everytime when progress is being updated, update the team OKR progress and company OKR progress
      if @personal_key_result.update(personal_key_result_params)
        # Activate the cascade OKR update functions
        update_okr_modules(@personal_key_result.personal_objective_id, @personal_key_result.id, @personal_key_result.progress)

        generate_log_when_update(@personal_key_result.progress, @@progress_before_update, @personal_key_result.id, @personal_key_result.personal_objective_id)

        format.html { redirect_to @personal_key_result, notice: 'Personal key result was successfully updated.' }
        format.json { render :show, status: :ok, location: @personal_key_result }
      else
        format.html { render :edit }
        format.json { render json: @personal_key_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /personal_key_results/1
  # DELETE /personal_key_results/1.json
  def destroy

    @log_content = 'Deleted <span><del>' + @personal_key_result.key_result + '</del></span>'

    LogPersonalObjective.create!(log_content: @log_content, personal_objective_id: @personal_key_result.personal_objective_id, user_id: current_user.id)
    LogPersonalKeyResult.where(personal_key_result_id: @personal_key_result.id).destroy_all()
    Contribution.where(personal_key_result_id: @personal_key_result.id).destroy_all()
    @personal_key_result.destroy
    # Activate the cascade OKR update functions
    delete_personal_key_result(@personal_key_result.personal_objective_id)

    respond_to do |format|
      format.html { redirect_to '/', notice: 'Personal key result was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # Customize API for creating and updating the key result
  def create_new_key_result
    @key_result = params["key_result"]
    @personal_objective_id = params["personal_objective_id"]

    @personal_objective = PersonalObjective.where(id: @personal_objective_id)
    @log_content = 'Created <span class="bold">' + @key_result + '</span> and aligned with <span class="bold">' + @personal_objective[0].objective + '</span>'
    @temp = PersonalKeyResult.create!(progress: 0.0, key_result: @key_result , personal_objective_id: @personal_objective_id)
    
    @log_personal_key_result = LogPersonalKeyResult.new(log_content: @log_content, personal_key_result_id:@temp.id, user_id: current_user.id)     
    @log_personal_key_result.save

    # Activate the cascade OKR update functions
    update_okr_modules(@personal_objective_id, @temp.id, @temp.progress)
  end

  def update_progress_key_result
    @key_result_id = params["id"]
    @progress = params["progress"]
    @progress_decimal = BigDecimal.new(@progress)
    @initial_progress = params["initial"]
    @initial_progress_decimal = BigDecimal.new(@initial_progress)
    @contribution = params["contribution"]

    @personal_key_result = PersonalKeyResult.where(id: @key_result_id)

    puts @personal_key_result[0].personal_objective_id
    # Update functions for the personal key result
    PersonalKeyResult.where(id: @key_result_id).update_all(progress: @progress)
    # Activate the cascade OKR update functions
    update_okr_modules(@personal_key_result[0].personal_objective_id, @key_result_id, @progress)
    @log_personal_key_result_id = generate_log_when_update(@progress_decimal, @initial_progress_decimal, @key_result_id, @personal_key_result[0].personal_objective_id)
    # Save into contribution module
    Contribution.create!(contribution_comment: @contribution, personal_key_result_id: @key_result_id, log_personal_key_result_id: @log_personal_key_result_id) 
  end

  def update_key_result_status
    @key_result_id = params[:id]
    @is_completed = params[:completed]
    PersonalKeyResult.where(id: @key_result_id).update_all(is_completed: @is_completed)
    @personal_key_result = PersonalKeyResult.where(id: @key_result_id)
    update_okr_modules(@personal_key_result[0].personal_objective_id, @key_result_id, @personal_key_result[0].progress)
    if(@is_completed == "true")
      @log_content = "Marked this key result as completed"
      @log_personal_key_result = LogPersonalKeyResult.new(log_content: @log_content, personal_key_result_id:@key_result_id, user_id: current_user.id)     
      @log_personal_key_result.save
    else
      LogPersonalKeyResult.where(log_content: "Marked this key result as completed", personal_key_result_id: @key_result_id).destroy_all()
    end
  end

  def details
    @key_result_id = params[:id]

    @personal_key_result = PersonalKeyResult.where(id: @key_result_id)
    @personal_objective = PersonalObjective.where(id: @personal_key_result[0].personal_objective_id)
    
    @current_date = Time.now.strftime("%Y-%m-%d") 
    @timeframe_logs = TimeframeLog.where("start_date <= '" + @current_date + "'") 
    @current_timeframe_log = TimeframeLog.where("(start_date,end_date) overlaps ('" + @current_date + "'::DATE,'" + @current_date + "'::DATE)") 
    @remaining_quarter_days = @current_timeframe_log[0].end_date - Time.now.to_date 

    @user_info = User.where(id: @personal_objective[0].user_id)
    @timeframe_log = TimeframeLog.where(id: @personal_objective[0].timeframe_log_id)

    @log = LogPersonalKeyResult.where(personal_key_result_id: @key_result_id).order(id: :DESC)

    render "app/personal_key_result_details"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_personal_key_result
      @personal_key_result = PersonalKeyResult.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def personal_key_result_params
      params.require(:personal_key_result).permit(:key_result, :progress, :personal_objective_id, contributions_attributes:[:id,:contribution_comment], log_personal_key_results_attributes:[:log_content,:personal_key_result_id])
    end

    # Cascade functions in updating the OKR from personal to company
    def update_okr_modules(personal_objective_id,personal_key_result_id,personal_key_result_progress)

      @personal_objective_progress = update_personal_objective_progress(personal_objective_id,personal_key_result_id,personal_key_result_progress)
        
      # Update the progress of the personal objective
      PersonalObjective.where(id: personal_objective_id).update_all(progress: @personal_objective_progress)
      
      # Search for the related team key result id
      @okr_team_personals = OkrTeamPersonal.where(personal_objective_id: personal_objective_id)
      @team_key_result_id = @okr_team_personals[0].team_key_result_id
      @team_key_result_progress = update_team_key_result_progress(@team_key_result_id,personal_objective_id)
      # Update the progress of the team key results
      TeamKeyResult.where(id: @team_key_result_id).update_all(progress: @team_key_result_progress)

      # Search for the related team objective id
      @team_key_result = TeamKeyResult.where(id: @team_key_result_id)
      @team_objective_id = @team_key_result[0].team_objective_id
      @team_objective_progress = update_team_objective_progress(@team_objective_id, @team_key_result_id)
      # Update the progress of the team objectives
      TeamObjective.where(id: @team_objective_id).update_all(progress: @team_objective_progress)

      # Search for the related company key result id
      @okr_company_team = OkrCompanyTeam.where(team_objective_id: @team_objective_id)
      @company_key_result_id = @okr_company_team[0].company_key_result_id
      @company_key_result_progress = update_company_key_result_progress(@company_key_result_id,@team_objective_id)
      # Update the progress of the company key results
      CompanyKeyResult.where(id: @company_key_result_id).update_all(progress: @company_key_result_progress)

      # Search for the related company objective id
      @company_key_result = CompanyKeyResult.where(id: @company_key_result_id)
      @company_objective_id = @company_key_result[0].company_objective_id
      @company_objective_progress = update_company_objective_progress(@company_objective_id,@company_key_result_id)
      # Update the progress of the company objective
      CompanyObjective.where(id: @company_objective_id).update_all(progress: @company_objective_progress)

    end

    # Delete functions catered for delete Personal Key Result
    def delete_personal_key_result(personal_objective_id)

      # Reduce the number of key result and drop the progress
      @personal_objective_progress = update_personal_objective_progress_delete_func(personal_objective_id)

      # Update the progress of the personal objective
      PersonalObjective.where(id: personal_objective_id).update_all(progress: @personal_objective_progress)
      
      # Search for the related team key result id
      @okr_team_personals = OkrTeamPersonal.where(personal_objective_id: personal_objective_id)
      @team_key_result_id = @okr_team_personals[0].team_key_result_id
      @team_key_result_progress = update_team_key_result_progress(@team_key_result_id,personal_objective_id)
      # Update the progress of the team key results
      TeamKeyResult.where(id: @team_key_result_id).update_all(progress: @team_key_result_progress)

      # Search for the related team objective id
      @team_key_result = TeamKeyResult.where(id: @team_key_result_id)
      @team_objective_id = @team_key_result[0].team_objective_id
      @team_objective_progress = update_team_objective_progress(@team_objective_id, @team_key_result_id)
      # Update the progress of the team objectives
      TeamObjective.where(id: @team_objective_id).update_all(progress: @team_objective_progress)

      # Search for the related company key result id
      @okr_company_team = OkrCompanyTeam.where(team_objective_id: @team_objective_id)
      @company_key_result_id = @okr_company_team[0].company_key_result_id
      @company_key_result_progress = update_company_key_result_progress(@company_key_result_id,@team_objective_id)
      # Update the progress of the company key results
      CompanyKeyResult.where(id: @company_key_result_id).update_all(progress: @company_key_result_progress)

      # Search for the related company objective id
      @company_key_result = CompanyKeyResult.where(id: @company_key_result_id)
      @company_objective_id = @company_key_result[0].company_objective_id
      @company_objective_progress = update_company_objective_progress(@company_objective_id,@company_key_result_id)
      # Update the progress of the company objective
      CompanyObjective.where(id: @company_objective_id).update_all(progress: @company_objective_progress)

    end

    def generate_log_when_update(personal_kr_progress, initial_progress, personal_kr_id, personal_objective_id)

      # Contribution towards the personal key result (Log)
      @personal_key_result = PersonalKeyResult.where(id: personal_kr_id)

      @progress_difference =  personal_kr_progress - initial_progress
      @log_content = 'Contributed <span class="bold">+' + @progress_difference.to_s + '%</span>'
      @log_personal_key_result = LogPersonalKeyResult.new(log_content: @log_content, personal_key_result_id: personal_kr_id, user_id: current_user.id)     
      @log_personal_key_result.save

      # Contribution towards the personal objective (Log)
      @personal_objectives = PersonalKeyResult.where(personal_objective_id: personal_objective_id)
      @personal_objective_progress_portion = @progress_difference / @personal_objectives.count
      @log_content = 'Contributed <span class="bold">+' + ('%.02f' % @personal_objective_progress_portion).to_s + '%</span> via <p class="bold">' + @personal_key_result[0].key_result + '</p>'
      LogPersonalObjective.create!(log_content: @log_content, personal_objective_id: personal_objective_id, user_id: current_user.id)
      
      # Generate log for team key result
      @okr_team_personal = OkrTeamPersonal.where(personal_objective_id: personal_objective_id)
      @team_key_results = OkrTeamPersonal.where(team_key_result_id: @okr_team_personal[0].team_key_result_id)
      @team_kr_progress_portion = @personal_objective_progress_portion / @team_key_results.count
      @log_content = 'Contributed <span class="bold">+' + ('%.02f' % @team_kr_progress_portion).to_s + '%</span> via <p class="bold">' + @personal_key_result[0].key_result + '</p>'
      LogTeamKeyResult.create!(log_content: @log_content, team_key_result_id: @okr_team_personal[0].team_key_result_id, user_id: current_user.id)
      
      # Generate log for team objective
      @team_key_result = TeamKeyResult.where(id: @okr_team_personal[0].team_key_result_id)
      @team_objectives = TeamKeyResult.where(team_objective_id: @team_key_result[0].team_objective_id)
      @team_objective_progress_portion = @team_kr_progress_portion / @team_objectives.count
      @log_content = 'Contributed <span class="bold">+' + ('%.02f' % @team_objective_progress_portion).to_s + '%</span> via <p class="bold">' + @personal_key_result[0].key_result + '</p>'
      LogTeamObjective.create!(log_content: @log_content, team_objective_id: @team_key_result[0].team_objective_id, user_id: current_user.id)
      
      # Generate log for company key result
      @okr_company_team = OkrCompanyTeam.where(team_objective_id: @team_key_result[0].team_objective_id)
      @company_key_results = OkrCompanyTeam.where(company_key_result_id: @okr_company_team[0].company_key_result_id)
      @company_kr_progress_portion = @team_objective_progress_portion / @company_key_results.count
      @log_content = 'Contributed <span class="bold">+' + ('%.02f' % @company_kr_progress_portion).to_s + '%</span> via <p class="bold">' + @personal_key_result[0].key_result + '</p>'
      LogCompanyKeyResult.create!(log_content: @log_content, company_key_result_id: @okr_company_team[0].company_key_result_id, user_id: current_user.id)
      
      # Generate log for company objective
      @company_key_result = CompanyKeyResult.where(id: @okr_company_team[0].company_key_result_id)
      @company_objectives = CompanyKeyResult.where(company_objective_id: @company_key_result[0].company_objective_id)
      @company_objective_progress_portion = @company_kr_progress_portion / @company_objectives.count
      @log_content = 'Contributed <span class="bold">+' + ('%.02f' % @company_objective_progress_portion).to_s + '%</span> via <p class="bold">' + @personal_key_result[0].key_result + '</p>'
      LogCompanyObjective.create!(log_content: @log_content, company_objective_id: @company_key_result[0].company_objective_id, user_id: current_user.id)

      return @log_personal_key_result.id
    end

    # --------------------------------------------------------
    # Core Algorithm for Personal OKR Calculations and Updates
    # --------------------------------------------------------
    # Perform action whenever the progress is being updated or created or deleted
    # Lowest layer: Update the Personal Objective Progress
    def update_personal_objective_progress(personal_objective_id,personal_key_result_id,personal_key_result_progress)
      
      # 1st calculate how many key results are tied to the linked objective
      @personal_key_result_amt = PersonalKeyResult.where(personal_objective_id: personal_objective_id).count
      puts @personal_key_result_amt
      if(@personal_key_result_amt == 0)
        @personal_objective_progress = 0.0
      else
        # Check how many is completed key result
        @temp_personal_key_result_amt = @personal_key_result_amt
        @completed_key_result_amt = PersonalKeyResult.where(personal_objective_id: personal_objective_id, is_completed: true).count
        @personal_key_result_amt = @personal_key_result_amt - @completed_key_result_amt
  
        # Divide personal objective progress with the key result amount
        @total_progress = 100.00
        @personal_objective_progress = 0.00
        @personal_objective_progress_portion = @total_progress / @personal_key_result_amt

        @true_count = 0;

        # Check and obtain the other related key result progress and objective portion progress
        PersonalKeyResult.where(personal_objective_id: personal_objective_id).each do |kr|
          if(kr.is_completed != true)
            if(kr.id == personal_key_result_id)
              # Obtain the progress for objective after total with other related key result progress
              @personal_objective_progress_diff = (personal_key_result_progress / @total_progress) * @personal_objective_progress_portion;
              # End product of the progress for the objective
              @personal_objective_progress = @personal_objective_progress_diff + @personal_objective_progress
            else
              @other_key_result_overall_progress = (kr.progress / 100.00) * @personal_objective_progress_portion
              @personal_objective_progress = @other_key_result_overall_progress + @personal_objective_progress
            end
          end
        end

        if(@completed_key_result_amt > 0)
          if(@completed_key_result_amt == @temp_personal_key_result_amt)
            @personal_objective_progress = 100.00
          end
        end
      end 

      return @personal_objective_progress

    end

    def update_personal_objective_progress_delete_func(personal_objective_id)
      # 1st calculate how many key results are tied to the linked objective
      @personal_key_result_amt = PersonalKeyResult.where(personal_objective_id: personal_objective_id).count

      # Divide personal objective progress with the key result amount
      @total_progress = 100.00
      @personal_objective_progress = 0.00
      @personal_objective_progress_portion = @total_progress / @personal_key_result_amt

      # Remove the progress of the current key result

      # Check and obtain the other related key result progress and objective portion progress
      PersonalKeyResult.where(personal_objective_id: personal_objective_id).each do |kr|
  
          @other_key_result_overall_progress = (kr.progress / 100.00) * @personal_objective_progress_portion
          @personal_objective_progress = @other_key_result_overall_progress + @personal_objective_progress
        
      end 
      
      return @personal_objective_progress
      
    end

    # 2nd Layer: Update the progress for the team key results
    def update_team_key_result_progress(team_key_result_id,personal_objective_id)

      # 1st calculate how many personal objectives are tied to the linked team key results
      @personal_objective_amt = OkrTeamPersonal.where(team_key_result_id: team_key_result_id).count

      # Divide team key result progress with the personal objective amount
      @total_progress = 100.00
      @team_key_result_progress = 0.00
      @team_key_result_progress_portion = @total_progress / @personal_objective_amt

      # Check and obtain the other related personal objective progress and team key result portion progress
      OkrTeamPersonal.where(team_key_result_id: team_key_result_id).each do |entry|

        @selected_personal_objective = PersonalObjective.where(id: entry.personal_objective_id)
        @selected_personal_objective_progress = @selected_personal_objective[0].progress
        @personal_objective_progress_portion = (@selected_personal_objective_progress / @total_progress) * @team_key_result_progress_portion
        @team_key_result_progress = @personal_objective_progress_portion + @team_key_result_progress

      end 

      return @team_key_result_progress

    end

    # 3rd Layer: Update the progress for the team objectives
    def update_team_objective_progress(team_objective_id, team_key_result_id)

      # 1st calculate how many team key results are tied to the linked team objective
      @team_key_result_amt = TeamKeyResult.where(team_objective_id: team_objective_id).count

      # Divide team objective progress with the related key result amount
      @total_progress = 100.00
      @team_objective_progress = 0.00
      @team_objective_progress_portion = @total_progress / @team_key_result_amt
      @temp_objective_progress = 0.00;

      # Check other related team key result progress and obtain the team objective portion progress
      TeamKeyResult.where(team_objective_id: team_objective_id).each do |entry|

        @selected_team_key_result_progress = entry.progress
        @temp_objective_progress = (@selected_team_key_result_progress / @total_progress) * @team_objective_progress_portion
        @team_objective_progress = @temp_objective_progress + @team_objective_progress

      end 

      return @team_objective_progress

    end

    # 4th Layer: Update the progress for company key results
    def update_company_key_result_progress(company_key_result_id, team_objective_id)

      # 1st calculate how many team objectives are linked to the company key results
      @company_key_result_amt = OkrCompanyTeam.where(company_key_result_id: company_key_result_id).count

      # Divide company key result progress with the related team objective amount 
      @total_progress = 100.00
      @company_key_result_progress = 0.00
      @company_key_result_progress_portion = @total_progress / @company_key_result_amt
      @temp_company_key_result_progress = 0.00

      # Check other related team objective progress and obtain the company key result portion progress
      OkrCompanyTeam.where(company_key_result_id: company_key_result_id).each do |entry|

        @selected_team_objective = TeamObjective.where(id: entry.team_objective_id)
        @selected_team_objective_progress = @selected_team_objective[0].progress
        @temp_company_key_result_progress = (@selected_team_objective_progress / @total_progress) * @company_key_result_progress_portion
        @company_key_result_progress = @temp_company_key_result_progress + @company_key_result_progress

      end

      return @company_key_result_progress

    end

    # 5th Layer: Update the progress for the company objective
    def update_company_objective_progress(company_objective_id, company_key_result_id)

      # 1st calculate how many company key results are linked to the company objective
      @company_key_result_amt = CompanyKeyResult.where(company_objective_id: company_objective_id).count

      # Divide company objective progress with the related company key result amount
      @total_progress = 100.00
      @company_objective_progress = 0.00
      @company_objective_progress_portion = @total_progress / @company_key_result_amt
      @temp_company_objective_progress = 0.00

      # Check other related company key result progress and obtain the company objective portion progress
      CompanyKeyResult.where(company_objective_id: company_objective_id).each do |entry|

        @selected_company_key_result_progress = entry.progress
        @temp_company_objective_progress = (@selected_company_key_result_progress / @total_progress) * @company_objective_progress_portion
        @company_objective_progress = @temp_company_objective_progress + @company_objective_progress

      end

      return @company_objective_progress

    end
    
end
