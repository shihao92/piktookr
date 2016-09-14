# Date : 5 August 2016
# Completed module : Create, Read and Update feature for OKR Module
# To be completed module : Delete OKR

class TeamKeyResultsController < ApplicationController
  before_action :set_team_key_result, only: [:show, :edit, :update, :destroy]

  # GET /team_key_results
  # GET /team_key_results.json
  def index
    @team_key_results = TeamKeyResult.all
  end

  # GET /team_key_results/1
  # GET /team_key_results/1.json
  def show
  end

  # GET /team_key_results/new
  def new
    @team_key_result = TeamKeyResult.new
  end

  # GET /team_key_results/1/edit
  def edit
  end

  # POST /team_key_results
  # POST /team_key_results.json
  def create
    @team_key_result = TeamKeyResult.new(team_key_result_params.merge(progress: 0.0,team_objective_id: params[:team_objective][:id]))
    respond_to do |format|
      if @team_key_result.save
        update_okr_modules(@team_key_result.team_objective_id, @team_key_result.id, 0.00)

        @team_objective = TeamObjective.where(id: @team_key_result.team_objective_id)

        @log_content = 'Created <span class="bold">' + @team_key_result.key_result + '</span> and aligned with <span class="bold">' + @team_objective[0].objective + '</span>' 

        LogTeamKeyResult.create!(log_content: @log_content, team_key_result_id: @team_key_result.id, user_id: current_user.id)

        format.html { redirect_to @team_key_result, notice: 'Team key result was successfully created.' }
        format.json { render :show, status: :created, location: @team_key_result }
      else
        format.html { render :new }
        format.json { render json: @team_key_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /team_key_results/1
  # PATCH/PUT /team_key_results/1.json
  def update
    respond_to do |format|
      if @team_key_result.update(team_key_result_params)
        update_okr_modules(@team_key_result.team_objective_id, @team_key_result.id, @team_key_result.progress)
        format.html { redirect_to @team_key_result, notice: 'Team key result was successfully updated.' }
        format.json { render :show, status: :ok, location: @team_key_result }
      else
        format.html { render :edit }
        format.json { render json: @team_key_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /team_key_results/1
  # DELETE /team_key_results/1.json
  def destroy
    # Find which team the team key result belongs to
    @team_objective = TeamObjective.where(id: @team_key_result.team_objective_id)
    
    # Temporarily implementation - Delete log team key result whenever user want to delete the team key result
    @log_content = 'Deleted <span><del>' + @team_key_result.key_result + '</del></span>'

    LogTeamObjective.create!(log_content: @log_content, team_objective_id: @team_key_result.team_objective_id, user_id: current_user.id)
    LogTeamKeyResult.where(team_key_result_id: @team_key_result.id).destroy_all()
    @team_key_result.destroy
    delete_team_key_result(@team_key_result.team_objective_id)
    respond_to do |format|
      format.html { redirect_to '/team_objectives/team_dashboard/' + @team_objective[0].okr_team_id.to_s, notice: 'Team key result was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # Required in OLD Prototype only
  # At team key result, obtain the team id and populate team objectives in the dropdown
  def get_team_objective
    @okr_team_id = params[:id]
    @team_objectives = TeamObjective.where(okr_team_id:@okr_team_id) 
    render json: @team_objectives, status: :ok
  end

  def details
    @key_result_id = params[:id]
    @team_id = params[:team_id]

    @okr_team = OkrTeam.where(id: @team_id)
    @team_key_result = TeamKeyResult.where(id: @key_result_id)
    @team_objective = TeamObjective.where(id: @team_key_result[0].team_objective_id)
    @user_info = User.where(id: @team_key_result[0].user_id)

    @log = LogTeamKeyResult.where(team_key_result_id: @key_result_id).order(id: :DESC)

    @temp_personal_objective = []
    @okr_team_personals = OkrTeamPersonal.where(team_key_result_id: @key_result_id)
    @okr_team_personals.each do |item|
      @personal_objective = PersonalObjective.where(id: item.personal_objective_id).all.map{|obj| [obj.objective]}
      @temp_personal_objective.push(@personal_objective)
    end

    @current_date = Time.now.strftime("%Y-%m-%d") 
    @timeframe_logs = TimeframeLog.where("start_date <= '" + @current_date + "'") 
    @timeframe_log = TimeframeLog.where("(start_date,end_date) overlaps ('" + @current_date + "'::DATE,'" + @current_date + "'::DATE)") 
    @remaining_quarter_days = @timeframe_log[0].end_date - Time.now.to_date

    render 'app/team_key_result_details'
  end

  def create_new_key_result
    @key_result = params['key_result']
    @team_objective_id = params['team_objective_id']

    @team_objective = TeamObjective.find(@team_objective_id)
    @log_content = 'Created <span class="bold">' + @key_result + '</span> and aligned with <span class="bold">' + @team_objective.objective + '</span>'
    @new_team_key_result = TeamKeyResult.new(
      progress: 0.0, 
      key_result: @key_result , 
      team_objective_id: @team_objective_id, 
      user_id: current_user.id
    )
    respond_to do |format|
      if @new_team_key_result.save
        LogTeamKeyResult.create!(log_content: @log_content, team_key_result_id: @new_team_key_result.id, user_id: current_user.id)
        update_okr_modules(@team_objective_id, @new_team_key_result.id, 0.00)
        format.json { render json: 'Team Key Result is created successfully!', status: :ok }
      else
        format.json { render json: 'Fail to create team key result!', status: :unprocessable_entity }
      end
    end
  end

  def edit_key_result
    @key_result_id = params['id']
    @edited_key_result = params['edited_key_result']
    @original_key_result = params['original_key_result']

    respond_to do |format|
      if TeamKeyResult.where(id: @key_result_id).update_all(key_result: @edited_key_result)
        @log_content = 'Renamed <del>' + @original_key_result + '</del> to <span class="bold">' + @edited_key_result + '</span>'
        LogTeamKeyResult.create!(log_content: @log_content, team_key_result_id: @key_result_id, user_id: current_user.id)
        format.json { render json: 'Team Key Result is updated successfully!', status: :ok }
      else
        format.json { render json: 'Fail to update team key result!', status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team_key_result
      @team_key_result = TeamKeyResult.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_key_result_params
      params.require(:team_key_result).permit(:key_result,:progress,:team_objective_id);
    end

    def update_okr_modules(team_objective_id, team_key_result_id, team_key_result_progress)

      @team_objective_progress = update_team_objective_progress(team_objective_id, team_key_result_id,team_key_result_progress)
      # Update the progress of the team objectives
      TeamObjective.where(id: team_objective_id).update_all(progress: @team_objective_progress)

      # Search for the related company key result id
      @okr_company_team = OkrCompanyTeam.where(team_objective_id: team_objective_id)
      @company_key_result_id = @okr_company_team[0].company_key_result_id
      @company_key_result_progress = update_company_key_result_progress(@company_key_result_id,team_objective_id)
      # Update the progress of the company key results
      CompanyKeyResult.where(id: @company_key_result_id).update_all(progress: @company_key_result_progress)

      # Search for the related company objective id
      @company_key_result = CompanyKeyResult.where(id: @company_key_result_id)
      @company_objective_id = @company_key_result[0].company_objective_id
      @company_objective_progress = update_company_objective_progress(@company_objective_id,@company_key_result_id)
      # Update the progress of the company objective
      CompanyObjective.where(id: @company_objective_id).update_all(progress: @company_objective_progress)

    end

    def delete_team_key_result(team_objective_id)

      @team_objective_progress = update_team_objective_progress_delete_func(team_objective_id)

      # Update the progress of the team objectives
      TeamObjective.where(id: team_objective_id).update_all(progress: @team_objective_progress)

      # Search for the related company key result id
      @okr_company_team = OkrCompanyTeam.where(team_objective_id: team_objective_id)
      @company_key_result_id = @okr_company_team[0].company_key_result_id
      @company_key_result_progress = update_company_key_result_progress(@company_key_result_id,team_objective_id)
      # Update the progress of the company key results
      CompanyKeyResult.where(id: @company_key_result_id).update_all(progress: @company_key_result_progress)

      # Search for the related company objective id
      @company_key_result = CompanyKeyResult.where(id: @company_key_result_id)
      @company_objective_id = @company_key_result[0].company_objective_id
      @company_objective_progress = update_company_objective_progress(@company_objective_id,@company_key_result_id)
      # Update the progress of the company objective
      CompanyObjective.where(id: @company_objective_id).update_all(progress: @company_objective_progress)

    end

    # --------------------------------------------------------
    # Core Algorithm for Team OKR Calculations and Updates
    # --------------------------------------------------------
    # Perform action whenever the progress is being updated or created or deleted

    # 3rd Layer: Update the progress for the team objectives
    def update_team_objective_progress(team_objective_id, team_key_result_id, team_key_result_progress)

      # 1st calculate how many team key results are tied to the linked team objective
      @team_key_result_amt = TeamKeyResult.where(team_objective_id: team_objective_id).count

      # Divide team objective progress with the related key result amount
      @total_progress = 100.00
      @team_objective_progress = 0.00
      @team_objective_progress_portion = @total_progress / @team_key_result_amt
      @temp_objective_progress = 0.00;

      # Check other related team key result progress and obtain the team objective portion progress
      TeamKeyResult.where(team_objective_id: team_objective_id).each do |entry|

        if (team_key_result_id == entry.id)
          @selected_team_key_result_progress = team_key_result_progress
          @temp_objective_progress = (@selected_team_key_result_progress / @total_progress) * @team_objective_progress_portion
          @team_objective_progress = @temp_objective_progress + @team_objective_progress
        else
          @selected_team_key_result_progress = entry.progress
          @temp_objective_progress = (@selected_team_key_result_progress / @total_progress) * @team_objective_progress_portion
          @team_objective_progress = @temp_objective_progress + @team_objective_progress
        end

      end 

      return @team_objective_progress

    end

    def update_team_objective_progress_delete_func(team_objective_id)

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
