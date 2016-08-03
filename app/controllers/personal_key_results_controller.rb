class PersonalKeyResultsController < ApplicationController
  before_action :set_personal_key_result, only: [:show, :edit, :update, :destroy]

  # GET /personal_key_results
  # GET /personal_key_results.json
  def index
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
      if @personal_key_result.update(personal_key_result_params)
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
    @personal_key_result.destroy
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
end
