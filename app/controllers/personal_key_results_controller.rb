# Date : 5 August 2016
# Completed module : Create, Read, Update and Delete feature for OKR Module
# Date : 1 September 2016
# Completed module : Log feature for OKR Module

class PersonalKeyResultsController < ApplicationController
  before_action :set_personal_key_result, only: [:edit, :update, :destroy]

  # GET /personal_key_results/new
  def new
    @personal_key_result = PersonalKeyResult.new
    @contribution = @personal_key_result.contributions.build
    @log_personal_key_result = @personal_key_result.contributions.build
  end

  # GET /personal_key_results/1/edit
  def edit
    @contribution = @personal_key_result.contributions.build
  end

  # POST /personal_key_results
  # POST /personal_key_results.json
  def create
    key_result = params[:key_result]
    personal_objective_id = params[:personal_objective_id] 
    status = PersonalKeyResult.new_personal_key_result(key_result, personal_objective_id, current_user.id)
    respond_to do |format|
      if status == 200     
        # update_okr_modules(personal_objective_id, new_personal_key_result.id, 0.00)
        format.json { render json: 'Personal Key Result is created successfully!', status: :ok }
      else 
        format.json { render json: 'Fail to create personal key result!', status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /personal_key_results/1
  # PATCH/PUT /personal_key_results/1.json
  def update
    respond_to do |format|
      # Everytime when progress is being updated, update the team OKR progress and company OKR progress
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
    status = PersonalKeyResult.delete_personal_key_result(@personal_key_result)
    respond_to do |format|
      if status == 200
        format.html { redirect_to '/', notice: 'Personal key result was successfully destroyed.' }
        format.json { head :no_content }
      else
        flash[:notice] = "Failed to delete personal key result."
      end
    end
  end

  # Customize API for creating and updating the key result
  def update_progress_key_result
    key_result_id = params[:id]
    progress = params[:progress]
    initial_progress = params[:initial]
    contribution = params[:contribution]
    progress_decimal = BigDecimal.new(progress)
    initial_progress_decimal = BigDecimal.new(initial_progress)
    personal_key_result = PersonalKeyResult.find(key_result_id) 

    status = PersonalKeyResult.update_progress_personal_key_result(
      key_result_id,
      progress_decimal,
      initial_progress_decimal,
      contribution,
      current_user.id
    )

    respond_to do |format|
      if status == 200
        format.json { render json: 'Progress of the key result is updated successfully!', status: :ok }
      else
        format.json { render json: 'Fail to update progress!', status: :unprocessable_entity }
      end
    end
  end

  def update_key_result_status
    key_result_id = params[:id]
    completed_flag = params[:completed]  
    personal_key_result = PersonalKeyResult.find(key_result_id)
    status = PersonalKeyResult.update_status_personal_key_result(key_result_id, personal_key_result.personal_objective_id, completed_flag, current_user.id)
    respond_to do |format|
      if status == 200
        format.json { render json: 'Status of the key result is updated successfully!', status: :ok }        
      else
        format.json { render json: 'Fail to update status!', status: :unprocessable_entity }
      end
    end
  end

  def edit_key_result
    key_result_id = params[:id]
    edited_key_result = params[:edited_key_result]
    original_key_result = params[:original_key_result]

    status = PersonalKeyResult.rename_personal_key_result(original_key_result, edited_key_result, key_result_id, current_user.id)

    respond_to do |format|
      if status == 200
        format.json { render json: 'Key result is updated successfully!', status: :ok }
      else
        format.json { render json: 'Fail to update key result!', status: :unprocessable_entity }
      end
    end
  end

  def insert_due_date
    key_result_id = params[:id]
    selected_due_date = params[:due_date]
    status = PersonalKeyResult.update_due_date(key_result_id, selected_due_date)
    respond_to do |format|
      if status == 200
        format.json { render json: 'Due date is created successfully!', status: :ok }
      else
        format.json { render json: 'Error!', status: :unprocessable_entity }
      end
    end
  end

  def details
    pages_initialization

    @key_result_id = params[:id]

    @personal_key_result = PersonalKeyResult.find(@key_result_id)
    @personal_objective = PersonalObjective.find(@personal_key_result.personal_objective_id)

    @user_info = User.find(@personal_objective.user_id)
    
    @obj_user_short_str = Shortform.get_string_shortform(@user_info.first_name)
    
    @timeframe_log = TimeframeLog.find(@personal_objective.timeframe_log_id)

    @log = LogPersonalKeyResult.where(personal_key_result_id: @key_result_id).order(id: :DESC)

    render "app/personal_key_result_details"
  end

  def get_contribution
    key_result_id = params[:id]
    contributions_log = LogPersonalKeyResult.retrieve_contribution(key_result_id)

    respond_to do |format|
      format.json { render json: contributions_log, status: :ok }
    end
  end

  def get_created_date
    key_result_id = params[:id]
    kr_created_date = PersonalKeyResult.retrieve_created_date(key_result_id)
    respond_to do |format|
      format.json { render json: kr_created_date, status: :ok }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_personal_key_result
      @personal_key_result = PersonalKeyResult.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def personal_key_result_params
      params.require(:personal_key_result).permit(:key_result, :progress, :personal_objective_id, contributions_attributes:[:id,:contribution_comment], log_personal_key_results_attributes:[:log_content,:personal_key_result_id])
    end

end
