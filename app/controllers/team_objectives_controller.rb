class TeamObjectivesController < ApplicationController
  before_action :set_team_objective, only: [:show, :edit, :update, :destroy]

  # GET /team_objectives
  # GET /team_objectives.json
  def index
    @team_objectives = TeamObjective.all
  end

  # GET /team_objectives/1
  # GET /team_objectives/1.json
  def show
  end

  # GET /team_objectives/new
  def new
    @team_objective = TeamObjective.new
  end

  # GET /team_objectives/1/edit
  def edit
  end

  # POST /team_objectives
  # POST /team_objectives.json
  def create
    @log = current_timeframe_log_id;
    @team_objective = TeamObjective.new(team_objective_params.merge(progress: 0.0,timeframe_log_id: @log[0].id,okr_team_id: params[:team][:team_id]))
    respond_to do |format|
      if @team_objective.save
        OkrCompanyTeam.create!(team_objective_id: @team_objective.id,company_key_result_id: params[:company_key_result][:kr_id])
        update_okr_modules(@team_objective.id,@team_objective.progress)
        format.html { redirect_to @team_objective, notice: 'Team objective was successfully created.' }
        format.json { render :show, status: :created, location: @team_objective }
      else
        format.html { render :new }
        format.json { render json: @team_objective.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /team_objectives/1
  # PATCH/PUT /team_objectives/1.json
  def update
    respond_to do |format|
      if @team_objective.update(team_objective_params)
        update_okr_modules(@team_objective.id,@team_objective.progress)
        format.html { redirect_to @team_objective, notice: 'Team objective was successfully updated.' }
        format.json { render :show, status: :ok, location: @team_objective }
      else
        format.html { render :edit }
        format.json { render json: @team_objective.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /team_objectives/1
  # DELETE /team_objectives/1.json
  def destroy
    @okr_company_team = OkrCompanyTeam.where(team_objective_id: team_objective.id)
    @company_key_result_id = @okr_company_team[0].company_key_result_id
    OkrCompanyTeam.where(team_objective_id: @team_objective.id).destroy_all
    @team_objective.destroy
    respond_to do |format|
      format.html { redirect_to team_objectives_url, notice: 'Team objective was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team_objective
      @team_objective = TeamObjective.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_objective_params
      params.require(:team_objective).permit(:objective,:progress,:timeframe_log_id,:okr_team_id);
    end

    # Obtain the current timeframe log id based on the current date
    def current_timeframe_log_id
      @current_date = DateTime.now.to_date.strftime("%Y-%m-%d");
      @log = TimeframeLog.where("(start_date, end_date) OVERLAPS ('" + @current_date + "'::DATE, '" + @current_date + "'::DATE)");
      return @log;
    end

    def update_okr_modules(team_objective_id,team_objective_progress)

      # Search for the related company key result id
      @okr_company_team = OkrCompanyTeam.where(team_objective_id: team_objective_id)
      @company_key_result_id = @okr_company_team[0].company_key_result_id
      @company_key_result_progress = update_company_key_result_progress(@company_key_result_id,team_objective_id,team_objective_progress)
      # Update the progress of the company key results
      CompanyKeyResult.where(id: @company_key_result_id).update_all(progress: @company_key_result_progress)

      # Search for the related company objective id
      @company_key_result = CompanyKeyResult.where(id: @company_key_result_id)
      @company_objective_id = @company_key_result[0].company_objective_id
      @company_objective_progress = update_company_objective_progress(@company_objective_id,@company_key_result_id)
      # Update the progress of the company objective
      CompanyObjective.where(id: @company_objective_id).update_all(progress: @company_objective_progress)

    end

    def delete_team_objective(company_key_result_id)

      @company_key_result_progress = update_company_key_result_progress_delete_func(company_key_result_id)
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

    # 4th Layer: Update the progress for company key results
    def update_company_key_result_progress(company_key_result_id, team_objective_id, team_objective_progress)

      # 1st calculate how many team objectives are linked to the company key results
      @company_key_result_amt = OkrCompanyTeam.where(company_key_result_id: company_key_result_id).count

      # Divide company key result progress with the related team objective amount 
      @total_progress = 100.00
      @company_key_result_progress = 0.00
      @company_key_result_progress_portion = @total_progress / @company_key_result_amt
      @temp_company_key_result_progress = 0.00

      # Check other related team objective progress and obtain the company key result portion progress
      OkrCompanyTeam.where(company_key_result_id: company_key_result_id).each do |entry|

        if (team_objective_id == entry.team_objective_id)
          @selected_team_objective_progress = team_objective_progress
          @temp_company_key_result_progress = (@selected_team_objective_progress / @total_progress) * @company_key_result_progress_portion
          @company_key_result_progress = @temp_company_key_result_progress + @company_key_result_progress
        else
          @selected_team_objective = TeamObjective.where(id: entry.team_objective_id)
          @selected_team_objective_progress = @selected_team_objective[0].progress
          @temp_company_key_result_progress = (@selected_team_objective_progress / @total_progress) * @company_key_result_progress_portion
          @company_key_result_progress = @temp_company_key_result_progress + @company_key_result_progress
        end

      end

      return @company_key_result_progress

    end

    def update_company_key_result_progress_delete_func(company_key_result_id)

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
