class CompanyObjectivesController < ApplicationController
  before_action :set_company_objective, only: [:show, :edit, :update, :destroy]

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
