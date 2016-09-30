class TimeframesController < ApplicationController
  before_action :set_timeframe, only: [:show, :edit, :update, :destroy]

  # GET /timeframes
  # GET /timeframes.json
  def index
    @timeframes = Timeframe.all
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
    @timeframe = Timeframe.new(timeframe_params)
    @start_date = Date.new(@timeframe.year,1,1);
    respond_to do |format|
      if @timeframe.save
        create_timeframe_log(@timeframe.timeframe_type)
        format.html { redirect_to @timeframe, notice: 'Timeframe was successfully created.' }
        format.json { render :show, status: :created, location: @timeframe }
      else
        format.html { render :new }
        format.json { render json: @timeframe.errors, status: :unprocessable_entity }
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

  def set_system_timeframe_log_id
    timeframe_id = params[:id]
    @@system_timeframe_log_id = timeframe_id
    respond_to do |format|
      format.json { render json: "Timeframe Log updated successfully!", status: :ok }
    end
  end

  def get_current_quarter_end_date
    timeframe_log = TimeframeLog.find(@@system_timeframe_log_id)
    respond_to do |format|
      format.json { render json: timeframe_log.end_date, status: :ok }
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
