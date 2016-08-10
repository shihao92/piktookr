# Date : 5 August 2016
# Completed module : Create, Read and Update feature for OKR Module
# To be completed module : Delete OKR

class PersonalKeyResultsController < ApplicationController
  before_action :set_personal_key_result, only: [:show, :edit, :update, :destroy]

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
  end

  # GET /personal_key_results/1/edit
  def edit
  end

  # POST /personal_key_results
  # POST /personal_key_results.json
  def create
    @personal_key_result = PersonalKeyResult.new(personal_key_result_params.merge(progress: 0.0, personal_objective_id: params[:personal_objective][:obj_id]))
    respond_to do |format|
      if @personal_key_result.save

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
      # Perform this after justification
      if @personal_key_result.update(personal_key_result_params)

        # Activate the cascade OKR update functions
        update_okr_modules(@personal_key_result.personal_objective_id,@personal_key_result.id,@personal_key_result.progress)

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
    # Set the progress back to 0 first then only destroy
    # Activate the cascade OKR update functions
    # update_okr_modules(@personal_key_result.personal_objective_id,@personal_key_result.id,0.00)
    @personal_key_result.destroy
    update_personal_objective_progress_delete_func(@personal_key_result.personal_objective_id)
    respond_to do |format|
      format.html { redirect_to personal_key_results_url, notice: 'Personal key result was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_personal_key_result
      @personal_key_result = PersonalKeyResult.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def personal_key_result_params
      params.require(:personal_key_result).permit(:key_result,:progress,:personal_objective_id)
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

    # --------------------------------------------------------
    # Core Algorithm for Personal OKR Calculations and Updates
    # --------------------------------------------------------
    # Perform action whenever the progress is being updated or created or deleted
    # Lowest layer: Update the Personal Objective Progress
    def update_personal_objective_progress(personal_objective_id,personal_key_result_id,personal_key_result_progress)
      
      # 1st calculate how many key results are tied to the linked objective
      @personal_key_result_amt = PersonalKeyResult.where(personal_objective_id: personal_objective_id).count

      # Divide personal objective progress with the key result amount
      @total_progress = 100.00
      @personal_objective_progress = 0.00
      @personal_objective_progress_portion = @total_progress / @personal_key_result_amt

      # Check and obtain the other related key result progress and objective portion progress
      PersonalKeyResult.where(personal_objective_id: personal_objective_id).each do |kr|
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
