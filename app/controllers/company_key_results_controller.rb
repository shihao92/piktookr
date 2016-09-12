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
    @company_key_result = CompanyKeyResult.new(company_key_result_params.merge(progress: 0.0,company_objective_id: params[:company_objective][:company_objective_id]))

    if @company_key_result.save
      update_okr_modules(@company_key_result.company_objective_id,@company_key_result.id)
      @company_objective = CompanyObjective.where(id: @company_key_result.company_objective_id)

      @log_content = 'Created <span class="bold">' + @company_key_result.key_result + '</span> and aligned with <span class="bold">' + @company_objective[0].objective + '</span>'

      LogCompanyKeyResult.create!(log_content: @log_content, company_key_result_id: @company_key_result.id, user_id: current_user.id)
      flash.notice = 'Company key result was successfully created.'
      redirect_to @company_key_result
    else
      flash.notice = 'Company key result was not able to be created.'
      redirect_to @company_key_result
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
    # Temporarily implementation - Delete log team key result whenever user want to delete the team key result

    @log_content = 'Deleted <span><del>' + @company_key_result.key_result + '</del></span>'

    LogCompanyObjective.create!(log_content: @log_content, company_objective_id: @company_key_result.company_objective_id, user_id: current_user.id)
    LogCompanyKeyResult.where(company_key_result_id: @company_key_result.id).destroy_all()
    if @company_key_result.destroy
      delete_company_key_result(@company_key_result.company_objective_id)
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

  def create_new_key_result
    @key_result = params['key_result']
    @company_objective_id = params['company_objective_id']

    @company_objective = CompanyObjective.find(@company_objective_id)
    @log_content = 'Created <span class="bold">' + @key_result + '</span> and aligned with <span class="bold">' + @company_objective.objective + '</span>'
    @new_company_key_result = CompanyKeyResult.create!(
      key_result: @key_result,
      progress: 0.0,
      company_objective_id: @company_objective_id,
      user_id: current_user.id
    )
    LogCompanyKeyResult.create!(
      log_content: @log_content, 
      company_key_result_id: @new_company_key_result.id, 
      user_id: current_user.id
    )
    update_okr_modules(@company_objective_id, @new_company_key_result.id)
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

    def update_okr_modules(company_objective_id,company_key_result_id)

      @company_objective_progress = update_company_objective_progress(company_objective_id, company_key_result_id)
      CompanyObjective.where(id: company_objective_id).update_all(progress: @company_objective_progress)

    end

    def delete_company_key_result(company_objective_id)

      @company_objective_progress = update_company_objective_progress_delete_func(company_objective_id)
      CompanyObjective.where(id: company_objective_id).update_all(progress: @company_objective_progress)

    end

    # --------------------------------------------------------
    # Core Algorithm for Team OKR Calculations and Updates
    # --------------------------------------------------------
    # Perform action whenever the progress is being updated or created or deleted

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

    def update_company_objective_progress_delete_func(company_objective_id)

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
