class CompanyKeyResultsController < ApplicationController
  before_action :set_company_key_result, only: [:show, :edit, :update, :destroy]

  # GET /company_key_results
  # GET /company_key_results.json
  def index
    @company_key_results = CompanyKeyResult.all
  end

  # GET /company_key_results/1
  # GET /company_key_results/1.json
  def show
  end

  # GET /company_key_results/new
  def new
    @company_key_result = CompanyKeyResult.new
  end

  # GET /company_key_results/1/edit
  def edit
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
    status = CompanyKeyResult.delete_company_key_result(@company_key_result)
    if status == 200
      flash.alert = 'Company key result was successfully destroyed.'
      redirect_to '/company_objectives/company_dashboard'
    else
      flash.alert = 'Not able to be deleted because there are other team key result aligned to it.'
      redirect_to '/company_objectives/company_dashboard'
    end
  end

  def details
    @key_result_id = params[:id]
    @company_key_result = CompanyKeyResult.find(@key_result_id)
    @company_objective = CompanyObjective.find(@company_key_result.company_objective_id)
    @user_info = User.where(id: @company_key_result.user_id)

    @log = LogCompanyKeyResult.where(company_key_result_id: @key_result_id).order(id: :DESC)

    @temp_team_objective = []
    @okr_company_teams = OkrCompanyTeam.where(company_key_result_id: @key_result_id)
    @okr_company_teams.each do |item|
      @team_objective = TeamObjective.where(id: item.team_objective_id).all.map{|obj| [obj.objective]}
      @temp_team_objective.push(@team_objective)
    end
    
    @current_date = Time.now.strftime("%Y-%m-%d") 
    @timeframe_logs = TimeframeLog.where("start_date <= '" + @current_date + "'") 
    @timeframe_log = TimeframeLog.where("(start_date,end_date) overlaps ('" + @current_date + "'::DATE,'" + @current_date + "'::DATE)") 
    @remaining_quarter_days = @timeframe_log[0].end_date - Time.now.to_date

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
