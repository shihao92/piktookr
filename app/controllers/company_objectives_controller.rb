class CompanyObjectivesController < ApplicationController
  before_action :set_company_objective, only: [:show, :edit, :update, :destroy]
  skip_before_action :set_company_objective, only: [:company_dashboard]
  
  # GET /company_objectives
  # GET /company_objectives.json
  def index
    @company_objectives = CompanyObjective.all
  end

  # GET /company_objectives/1
  # GET /company_objectives/1.json
  def show
  end

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
    @log = current_timeframe_log_id;
    @company_objective = CompanyObjective.new(company_objective_params.merge(progress: 0.0,timeframe_log_id: @log[0].id))
    respond_to do |format|
      if @company_objective.save

        @log_content = 'Created <span class="bold">' + @company_objective.objective + '</span>' 

        LogCompanyObjective.create!(log_content: @log_content, company_objective_id: @company_objective.id, user_id: current_user.id)

        format.html { redirect_to @company_objective, notice: 'Company objective was successfully created.' }
        format.json { render :show, status: :created, location: @company_objective }
      else
        format.html { render :new }
        format.json { render json: @company_objective.errors, status: :unprocessable_entity }
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
    LogCompanyObjective.where(company_objective_id: @company_objective.id).destroy_all()
    begin
      if @company_objective.destroy
        respond_to do |format|
          format.html { redirect_to company_objectives_url, notice: 'Company objective was successfully destroyed.' }
          format.json { head :no_content }
        end
      else
        respond_to do |format|
          format.html { redirect_to company_objectives_url, notice: 'There is other key result aligned with this company objective.' }
          format.json { head :no_content }
        end
      end
    rescue
      respond_to do |format|
        format.html { redirect_to company_objectives_url, notice: 'There is other key result aligned with this company objective.' }
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
      @current_date = Time.now.strftime("%Y-%m-%d") 
      @timeframe_logs = TimeframeLog.where("start_date <= '" + @current_date + "'") 
      @current_timeframe_log = TimeframeLog.where("(start_date,end_date) overlaps ('" + @current_date + "'::DATE,'" + @current_date + "'::DATE)") 
      @remaining_quarter_days = @current_timeframe_log[0].end_date - Time.now.to_date
    end

    render 'app/company_dashboard'
  end

  def details
    @objective_id = params[:id]
    @company_objective = CompanyObjective.find(@objective_id)
    @company_key_results = CompanyKeyResult.where(company_objective_id: @objective_id)
    @user_info = User.where(id: @company_objective.user_id)

    @log = LogCompanyObjective.where(company_objective_id: @objective_id).order(id: :DESC)

    @current_date = Time.now.strftime("%Y-%m-%d") 
    @timeframe_logs = TimeframeLog.where("start_date <= '" + @current_date + "'") 
    @timeframe_log = TimeframeLog.where("(start_date,end_date) overlaps ('" + @current_date + "'::DATE,'" + @current_date + "'::DATE)") 
    @remaining_quarter_days = @timeframe_log[0].end_date - Time.now.to_date

    render 'app/company_objective_details'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company_objective
      @company_objective = CompanyObjective.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_objective_params
      params.require(:company_objective).permit(:objective, :progress, :timeframe_log_id);
    end

    # Obtain the current timeframe log id based on the current date
    def current_timeframe_log_id
      @current_date = DateTime.now.to_date.strftime("%Y-%m-%d");
      @log = TimeframeLog.where("(start_date, end_date) OVERLAPS ('" + @current_date + "'::DATE, '" + @current_date + "'::DATE)");
      return @log;
    end
end
