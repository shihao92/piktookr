class TimeframeLog < ApplicationRecord

    has_one :timeframe
    has_many :company_objectives

    # Obtain the current timeframe log id based on the current date
    def self.current_timeframe_log_id
      current_date = DateTime.now.to_date.strftime("%Y-%m-%d");
      log = TimeframeLog.where("(start_date, end_date) OVERLAPS ('" + current_date + "'::DATE, '" + current_date + "'::DATE)");
      return log[0].id;
    end

end