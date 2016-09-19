class Timeframe < ApplicationRecord

    has_many :timeframe_logs

    def self.calculate_remaining_days_current_quarter
      current_date = Time.now.strftime("%Y-%m-%d") 
      current_timeframe_log = TimeframeLog.find_by("(start_date,end_date) overlaps ('" + current_date + "'::DATE,'" + current_date + "'::DATE)") 
      remaining_quarter_days = current_timeframe_log.end_date - Time.now.to_date
      return remaining_quarter_days
    end

end
