# Date : 5 August 2016
# Completed module : Create, Read and Update feature for OKR Module
# To be completed module : Delete OKR

class PersonalObjectivesController < ApplicationController
  before_action :set_personal_objective, only: [:show, :edit, :update, :destroy]

  # GET /personal_objectives
  # GET /personal_objectives.json
  def index
    @personal_objectives = PersonalObjective.all
  end

  # GET /personal_objectives/1
  # GET /personal_objectives/1.json
  def show
  end

  # GET /personal_objectives/new
  def new
    @personal_objective = PersonalObjective.new
  end

  # GET /personal_objectives/1/edit
  def edit
  end

  # POST /personal_objectives
  # POST /personal_objectives.json
  def create
    @log = current_timeframe_log_id;
    @personal_objective = PersonalObjective.new(personal_objective_params.merge(progress: 0.0,timeframe_log_id: @log[0].id, user_id: current_user.id))
    respond_to do |format|
      if @personal_objective.save
        OkrTeamPersonal.create!(team_key_result_id: params[:team_key_result][:id], personal_objective_id: @personal_objective.id)
        # Right after creation of new personal objective, update OKR progress 
        update_okr_modules(@personal_objective.id,0.00)
        format.html { redirect_to @personal_objective, notice: 'Personal objective was successfully created.' }
        format.json { render :show, status: :created, location: @personal_objective }
      else
        format.html { render :new }
        format.json { render json: @personal_objective.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /personal_objectives/1
  # PATCH/PUT /personal_objectives/1.json
  def update
    respond_to do |format|
      if @personal_objective.update(personal_objective_params)
        # Right after update progress of personal objective, update OKR progress 
        update_okr_modules(@personal_objective.id,@personal_objective.progress)
        format.html { redirect_to @personal_objective, notice: 'Personal objective was successfully updated.' }
        format.json { render :show, status: :ok, location: @personal_objective }
      else
        format.html { render :edit }
        format.json { render json: @personal_objective.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /personal_objectives/1
  # DELETE /personal_objectives/1.json
  def destroy
    @okr_team_personal = OkrTeamPersonal.where(personal_objective_id: @personal_objective.id)
    @team_key_result_id = @okr_team_personal[0].team_key_result_id
    OkrTeamPersonal.where(personal_objective_id: @personal_objective.id).destroy_all()
    @personal_objective.destroy
    delete_personal_objective(@team_key_result_id)
    respond_to do |format|
      format.html { redirect_to personal_objectives_url, notice: 'Personal objective was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def get_team_key_results
    @team_objective_id = params[:id]
    @team_key_results = TeamKeyResult.where(team_objective_id: @team_objective_id)
    render json: @team_key_results, status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_personal_objective
      @personal_objective = PersonalObjective.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def personal_objective_params
      params.require(:personal_objective).permit(:objective,:progress,:timeframe_log_id,:user_id);
    end

    # Obtain the current timeframe log id based on the current date
    def current_timeframe_log_id
      @current_date = DateTime.now.to_date.strftime("%Y-%m-%d");
      @log = TimeframeLog.where("(start_date, end_date) OVERLAPS ('" + @current_date + "'::DATE, '" + @current_date + "'::DATE)");
      return @log;
    end

    def update_okr_modules(personal_objective_id,personal_objective_progress)
      # Search for the related team key result id
      @okr_team_personals = OkrTeamPersonal.where(personal_objective_id: personal_objective_id)
      @team_key_result_id = @okr_team_personals[0].team_key_result_id
      @team_key_result_progress = update_team_key_result_progress(@team_key_result_id,personal_objective_id,personal_objective_progress)
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

    def delete_personal_objective(team_key_result_id)

      @team_key_result_progress = update_team_key_result_progress_delete_func(team_key_result_id)
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

    # --------------------------------------------------------
    # Core Algorithm for Personal OKR Calculations and Updates
    # --------------------------------------------------------
    # Perform action whenever the progress is being updated or created or deleted
    # 2nd Layer: Update the progress for the team key results
    def update_team_key_result_progress(team_key_result_id,personal_objective_id,personal_objective_progress)

      # 1st calculate how many personal objectives are tied to the linked team key results
      @personal_objective_amt = OkrTeamPersonal.where(team_key_result_id: team_key_result_id).count

      # Divide team key result progress with the personal objective amount
      @total_progress = 100.00
      @team_key_result_progress = 0.00
      @team_key_result_progress_portion = @total_progress / @personal_objective_amt

      # Check and obtain the other related personal objective progress and team key result portion progress
      OkrTeamPersonal.where(team_key_result_id: team_key_result_id).each do |entry|

        if(personal_objective_id == entry.personal_objective_id)
          @selected_personal_objective_progress = personal_objective_progress
          @personal_objective_progress_portion = (@selected_personal_objective_progress / @total_progress) * @team_key_result_progress_portion
          @team_key_result_progress = @personal_objective_progress_portion + @team_key_result_progress
        else
          @selected_personal_objective = PersonalObjective.where(id: entry.personal_objective_id)
          @selected_personal_objective_progress = @selected_personal_objective[0].progress
          @personal_objective_progress_portion = (@selected_personal_objective_progress / @total_progress) * @team_key_result_progress_portion
          @team_key_result_progress = @personal_objective_progress_portion + @team_key_result_progress
        end

      end 

      return @team_key_result_progress

    end

    def update_team_key_result_progress_delete_func(team_key_result_id)

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
