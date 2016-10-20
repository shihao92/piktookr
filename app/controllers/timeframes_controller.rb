class TimeframesController < ApplicationController
  before_action :set_timeframe, only: [:show, :edit, :update, :destroy]

  # GET /timeframes
  # GET /timeframes.json
  def index
    pages_initialization

    @timeframes = Timeframe.all
    @timeframe_logs = TimeframeLog.where('extract(year from start_date) = ?', Date.today.year).order(created_at: :ASC)
    @next_timeframe_logs = TimeframeLog.where('extract(year from start_date) = ?', Date.today.year + 1)
    @timeframe_logs_advanced_two_years = TimeframeLog.where('extract(year from start_date) = ?', Date.today.year + 2)
  end

  # GET /timeframes/1
  # GET /timeframes/1.json
  def show
  end

  # GET /timeframes/new
  def new
    @timeframe = Timeframe.new
  end

  # GET /timeframes/1/edit
  def edit
  end

  # POST /timeframes
  # POST /timeframes.json
  def create
    year = params[:year]
    timeframe_type = params[:type]

    timeframe = Timeframe.new(year: year, timeframe_type: timeframe_type)
    respond_to do |format|
      if timeframe.save
        TimeframeLog.create_timeframe_log(timeframe.year, timeframe.id, timeframe.timeframe_type)
        format.json { render json: "Timeframe successfully created!", status: :ok }
      else
        format.json { render json: "Error!", status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /timeframes/1
  # PATCH/PUT /timeframes/1.json
  def update
    respond_to do |format|
      if @timeframe.update(timeframe_params)
        format.html { redirect_to @timeframe, notice: 'Timeframe was successfully updated.' }
        format.json { render :show, status: :ok, location: @timeframe }
      else
        format.html { render :edit }
        format.json { render json: @timeframe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /timeframes/1
  # DELETE /timeframes/1.json
  def destroy
    TimeframeLog.destroy_all(timeframe_id: @timeframe.id)
    @timeframe.destroy
    respond_to do |format|
      format.html { redirect_to timeframes_url, notice: 'Timeframe was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def destroy_timeframe
    timeframe_id = params[:timeframe_id]
    respond_to do |format|
      if TimeframeLog.where(timeframe_id: timeframe_id).destroy_all()
        if Timeframe.find(timeframe_id).destroy
          format.json { render json: "Record removed successfully!", status: :ok }
        else
          format.json { render json: "Error!", status: :unprocessable_entity }
        end
      else
        format.json { render json: "Error!", status: :unprocessable_entity }
      end
    end
  end

  def set_system_timeframe_log_id
    timeframe_id = params[:id]
    OkrUserTimeframe.find_by(user_id: current_user.id).update(timeframe_log_id: timeframe_id)
    respond_to do |format|
      format.json { render json: "Timeframe Log updated successfully!", status: :ok }
    end
  end

  def get_current_quarter_end_date
    system_timeframe_log_id = params[:timeframe_log_id]
    timeframe_log = TimeframeLog.find(system_timeframe_log_id)
    respond_to do |format|
      format.json { render json: timeframe_log.end_date, status: :ok }
    end
  end

  def is_next_year_log_presence
    next_year_timeframe_logs = TimeframeLog.where('extract(year from start_date) = ?', Date.today.year + 1).order(created_at: :ASC)
    respond_to do |format|
      if next_year_timeframe_logs == nil
        format.json { render json: "Please setup the timeframe intervals for next year or system will set it automatically as quarter when the new year arrived.", status: :ok }
      else
        format.json { render json: "Timeframe for next year all set.", status: :ok }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_timeframe
      @timeframe = Timeframe.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def timeframe_params
      params.require(:timeframe).permit(:year,:timeframe_type)
    end

end
