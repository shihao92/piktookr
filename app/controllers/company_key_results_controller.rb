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

    respond_to do |format|
      if @company_key_result.save
        update_okr_modules(@company_key_result.company_objective_id,@company_key_result.id)
        format.html { redirect_to @company_key_result, notice: 'Company key result was successfully created.' }
        format.json { render :show, status: :created, location: @company_key_result }
      else
        format.html { render :new }
        format.json { render json: @company_key_result.errors, status: :unprocessable_entity }
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
    @company_key_result.destroy
    delete_company_key_result(@company_key_result.company_objective_id)
    respond_to do |format|
      format.html { redirect_to company_key_results_url, notice: 'Company key result was successfully destroyed.' }
      format.json { head :no_content }
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
