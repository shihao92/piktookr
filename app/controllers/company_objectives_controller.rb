class CompanyObjectivesController < ApplicationController
  
  # GET /company_objectives/new
  def new
    @company_objective = CompanyObjective.new
  end

  # GET /company_objectives/1/edit
  def edit
  end

  # POST /company_objectives
  # POST /company_objectives.json
  def create
    objective = params[:objective]
    status = CompanyObjective.new_company_objective(objective, current_user.id)
    respond_to do |format|
      if status == 200     
        format.json { render json: 'Company Objective is created successfully!', status: :ok }
      else
        format.json { render json: 'Fail to create company objective!', status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /company_objectives/1
  # PATCH/PUT /company_objectives/1.json
  def update
    respond_to do |format|
      if @company_objective.update(company_objective_params)
        format.html { redirect_to @company_objective, notice: 'Company objective was successfully updated.' }
        format.json { render :show, status: :ok, location: @company_objective }
      else
        format.html { render :edit }
        format.json { render json: @company_objective.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /company_objectives/1
  # DELETE /company_objectives/1.json
  def destroy
    company_objective_id = params[:id]
    status = CompanyObjective.delete_company_objective(company_objective_id)
    begin
      if status == 200
        respond_to do |format|
          format.html { redirect_to '/company_objectives/company_dashboard', notice: 'Company objective was successfully destroyed.' }
          format.json { head :no_content }
        end
      else
        respond_to do |format|
          format.html { redirect_to '/company_objectives/company_dashboard', notice: 'There is other key result aligned with this company objective.' }
          format.json { head :no_content }
        end
      end
    rescue
      respond_to do |format|
        format.html { redirect_to '/company_objectives/company_dashboard', notice: 'There is other key result aligned with this company objective.' }
        format.json { head :no_content }
      end
    end
  end

  def company_dashboard
    @company_objectives = CompanyObjective.all
    @completed_objectives = 0
    @temp_progress_buffer = 0.00
    @total_progress = 0

    if(@company_objectives.count != 0) 
      @temp_date = []
      @company_objectives.each do |item|
        if(item.progress == 100.00)
          @completed_objectives = @completed_objectives + 1
        end
        @temp_progress_buffer = item.progress + @temp_progress_buffer
        # To check which is the latest updated date 
        @temp_date << item.updated_at
        @date_max = @temp_date.max 
        @date_difference = (Time.now - @date_max) / 86400 
      end
      @percentage_completed_objective = (@completed_objectives.to_f / @company_objectives.count.to_f) * 100
      @total_progress = @temp_progress_buffer / @company_objectives.count
      # Timeframe module
      @remaining_quarter_days = Timeframe.calculate_remaining_days_current_quarter
    end

    render 'app/company_dashboard'
  end

  def details
    @objective_id = params[:id]
    @company_objective = CompanyObjective.find(@objective_id)
    @company_key_results = CompanyKeyResult.where(company_objective_id: @objective_id)
    @user_info = User.find(@company_objective.user_id)

    @log = LogCompanyObjective.where(company_objective_id: @objective_id).order(id: :DESC)

    @timeframe_log = TimeframeLog.find(@company_objective.timeframe_log_id)
    @remaining_quarter_days = Timeframe.calculate_remaining_days_current_quarter

    render 'app/company_objective_details'
  end

  def edit_objective
    objective_id = params[:id]
    edited_objective = params[:edited_objective]
    original_objective = params[:original_objective]
    
    status = CompanyObjective.rename_company_objective(original_objective, edited_objective, objective_id, current_user.id)

    respond_to do |format|
      if status == 200  
        format.json { render json: 'Company Objective is updated successfully!', status: :ok }
      else
        format.json { render json: 'Fail to update company objective!', status: :unprocessable_entity }
      end
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_objective_params
      params.require(:company_objective).permit(:objective, :progress, :timeframe_log_id);
    end
end
