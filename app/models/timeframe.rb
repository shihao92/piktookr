class Timeframe < ApplicationRecord

    # ---------
    # Relations
    # ---------

    has_many :timeframe_logs

    # -----------
    # Validations
    # -----------

    validates   :year, presence:  true, :numericality => { only_integer: true }
    validates   :timeframe_type, presence: true, length: { minimum: 2 }



    def self.calculate_remaining_days_current_quarter
      current_date = Time.now.strftime("%Y-%m-%d") 
      # Check whether the current date is start date or end date first
      is_start_date = TimeframeLog.find_by(start_date: current_date)
      if is_start_date == nil
        is_end_date = TimeframeLog.find_by(end_date: current_date)
        if is_end_date == nil
          current_timeframe_log = TimeframeLog.find_by("(start_date,end_date) overlaps ('" + current_date + "'::DATE,'" + current_date + "'::DATE)") 
          if current_timeframe_log == nil
            remaining_quarter_days = 1
          else
            remaining_quarter_days = current_timeframe_log.end_date - Time.now.to_date
          end
        else
          remaining_quarter_days = 1
        end
      else
        remaining_quarter_days = 90
      end
       
      return remaining_quarter_days
    end

end
