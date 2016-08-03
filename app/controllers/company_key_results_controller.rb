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
    @company_key_result = CompanyKeyResult.new(company_key_result_params.merge(progress: 0.0))

    respond_to do |format|
      if @company_key_result.save
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
      params.require(:company_key_result).permit(:key_result,:progress,:company_objective_id).merge(company_objective_id: params[:company_objective][:company_objective_id])
    end
end
