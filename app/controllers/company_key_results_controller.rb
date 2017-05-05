class CompanyKeyResultsController < ApplicationController
  before_action :set_company_key_result, only: [:show, :edit, :update, :destroy]

  def new
    @company_key_result = CompanyKeyResult.new
  end

  # POST /company_key_results
  # POST /company_key_results.json
  def create
    key_result = params[:key_result]
    company_objective_id = params[:company_objective_id]

    status = CompanyKeyResult.new_company_key_result(key_result, company_objective_id, current_user.id)
    
    respond_to do |format|
      if status == 200
        format.json { render json: 'Company Key Result is created successfully!', status: :ok }
      else
        format.json { render json: 'Fail to create company key result!', status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /company_key_results/1
  # PATCH/PUT /company_key_results/1.json
  def update
    respond_to do |format|
      if @company_key_result.update(company_key_result_params)
        
        format.html { redirect_to @company_key_result, notice: 'Company key result was successfully updated.' }
        format.json { render :show, status: :ok, location: @company_key_result }
      else
        format.html { render :edit }
        format.json { render json: @company_key_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /company_key_results/1
  # DELETE /company_key_results/1.json
  def destroy    
    okr_company_personal = OkrCompanyPersonal.find_by(company_key_result_id: @company_key_result.id)
    okr_company_team = OkrCompanyTeam.find_by(company_key_result_id: @company_key_result.id)
    if okr_company_personal == nil 
      if okr_company_team == nil 
        status = CompanyKeyResult.delete_company_key_result(@company_key_result)
      else
        status = 201
      end
    else
      status = 201
    end
    
    if status == 200
      flash.alert = 'Company key result was successfully destroyed.'
      redirect_to '/company_objectives/company_dashboard'
    else
      flash.alert = 'Not able to be deleted because there are other team key result aligned to it.'
      redirect_to '/company_objectives/company_dashboard'
    end
  end

  def details
    pages_initialization

    @key_result_id = params[:id]
    @company_key_result = CompanyKeyResult.find(@key_result_id)
    @company_objective = CompanyObjective.find(@company_key_result.company_objective_id)
    @co_user_info = User.find(@company_objective.user_id)
    @co_user_shortform = Shortform.get_string_shortform(@co_user_info.first_name)

    @user_info = User.find(@company_key_result.user_id)
    @user_shortform = Shortform.get_string_shortform(@user_info.first_name)

    @log = LogCompanyKeyResult.where(company_key_result_id: @key_result_id).order(id: :DESC)

    @temp_team_objective = []
    @okr_company_teams = OkrCompanyTeam.where(company_key_result_id: @key_result_id)
    @okr_company_teams.each do |item|
      @team_objective = TeamObjective.where(id: item.team_objective_id).all.map{|obj| [obj.id, obj.objective, obj.user_id, obj.okr_team_id]}
      @temp_team_objective.push(@team_objective)
    end

    @temp_personal_objective = []
    @okr_company_personals = OkrCompanyPersonal.where(company_key_result_id: @key_result_id)
    @okr_company_personals.each do |item|
      @personal_objective = PersonalObjective.where(id: item.personal_objective_id).all.map{|obj| [obj.id, obj.objective, obj.user_id]}
      @temp_personal_objective.push(@personal_objective)
    end
    
    @timeframe_log = TimeframeLog.find(@company_objective.timeframe_log_id)
    if @company_key_result.due_date != nil
      if @timeframe_log.end_date == @company_key_result.due_date
        @timeframe_day_difference = @remaining_quarter_days.to_i
      else
        @timeframe_day_difference = @company_key_result.due_date - Date.today
        if @timeframe_day_difference < 0 
          @timeframe_day_difference = 0
        end
      end
    else
      @timeframe_day_difference = @remaining_quarter_days.to_i
    end

    render 'app/company_key_result_details'
  end

  def edit_key_result
    key_result_id = params[:id]
    edited_key_result = params[:edited_key_result]
    original_key_result = params[:original_key_result]

    status = CompanyKeyResult.rename_company_key_result(original_key_result, edited_key_result, key_result_id, current_user.id)

    respond_to do |format|
      if status == 200
        format.json { render json: 'Company Key Result is updated successfully!', status: :ok }
      else
        format.json { render json: 'Fail to update company key result!', status: :unprocessable_entity }
      end
    end
  end

  def insert_due_date
    key_result_id = params[:id]
    selected_due_date = params[:due_date]
    status = CompanyKeyResult.update_due_date(key_result_id, selected_due_date)
    respond_to do |format|
      if status == 200
        format.json { render json: 'Due date is created successfully!', status: :ok }
      else
        format.json { render json: 'Error!', status: :unprocessable_entity }
      end
    end
  end

  def get_created_date
    key_result_id = params[:id]
    kr_created_date = CompanyKeyResult.retrieve_created_date(key_result_id)
    respond_to do |format|
      format.json { render json: kr_created_date, status: :ok }
    end
  end

  def get_contribution
    key_result_id = params[:id]
    contributions_log = LogCompanyKeyResult.retrieve_contribution(key_result_id)

    respond_to do |format|
      format.json { render json: contributions_log, status: :ok }
    end
  end

  def search_key_result
    keyword = params[:keyword]
    okr_user_timeframe = OkrUserTimeframe.find_by(user_id: current_user.id)
    result_key_results = CompanyKeyResult.search_key_result(keyword, okr_user_timeframe.timeframe_log_id)
    respond_to do |format|
      format.json { render json: result_key_results, status: :ok }  
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company_key_result
      @company_key_result = CompanyKeyResult.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_key_result_params
      params.require(:company_key_result).permit(:key_result,:progress,:company_objective_id)
    end

end
