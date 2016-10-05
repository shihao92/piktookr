class TimeframeLog < ApplicationRecord

    # ---------
    # Relations
    # ---------

    has_one :timeframe
    has_many :company_objectives

    # -----------
    # Validations
    # -----------

    validates   :start_date, presence: true
    validate    :start_date_cannot_be_in_the_past


    def start_date_cannot_be_in_the_past
      if start_date.present? && start_date < Date.today
        errors.add(:start_date, "can't be in the past")
      end
    end

    def end_date_cannot_be_in_the_past
      if end_date.present? && end_date < Date.today
        errors.add(:end_date, "can't be in the past")
      end
    end

    # Obtain the current timeframe log id based on the current date
    def self.current_timeframe_log_id
      current_date = DateTime.now.to_date.strftime("%Y-%m-%d");
      before_current_date = ""
      check_start_date = TimeframeLog.find_by(start_date: current_date)
      if check_start_date == nil
        check_end_date = TimeframeLog.find_by(end_date: current_date)
        if check_end_date == nil
          before_current_date = current_date
        else
          before_current_date = Date.today - 1
        end
      else
        before_current_date = current_date
      end
      log = TimeframeLog.where("(start_date, end_date) OVERLAPS ('" + before_current_date.to_s + "'::DATE, '" + current_date + "'::DATE)");
      return log[0].id;
    end

    def self.create_timeframe_log(timeframe_year, timeframe_id, period)
      start_date = Date.new(timeframe_year,1,1);
      if(period == "Yearly")
        end_date = Date.new(timeframe_year,12,31)
        TimeframeLog.create!(start_date: start_date,end_date: end_date,timeframe_id: timeframe_id,quarter: "Q1,Q2,Q3,Q4 " + timeframe_year.to_s)
      elsif(period == "Half Yearly")
        end_date = Date.new(timeframe_year,6,30)
        TimeframeLog.create!(start_date: start_date,end_date: end_date,timeframe_id: timeframe_id,quarter: "Q1,Q2 " + timeframe_year.to_s)
        start_date = Date.new(timeframe_year,7,1)
        end_date = Date.new(timeframe_year,12,31)
        TimeframeLog.create!(start_date: start_date,end_date: end_date,timeframe_id: timeframe_id,quarter: "Q3,Q4 " + timeframe_year.to_s)
      else
        # Quarterly period setting
        end_date = Date.new(timeframe_year,3,31)
        TimeframeLog.create!(start_date: start_date,end_date: end_date,timeframe_id: timeframe_id,quarter: "Q1 " + timeframe_year.to_s)
        start_date = Date.new(timeframe_year,4,1)
        end_date = Date.new(timeframe_year,6,30)
        TimeframeLog.create!(start_date: start_date,end_date: end_date,timeframe_id: timeframe_id,quarter: "Q2 " + timeframe_year.to_s)
        start_date = Date.new(timeframe_year,7,1)
        end_date = Date.new(timeframe_year,9,30)
        TimeframeLog.create!(start_date: start_date,end_date: end_date,timeframe_id: timeframe_id,quarter: "Q3 " + timeframe_year.to_s)
        start_date = Date.new(timeframe_year,10,1)
        end_date = Date.new(timeframe_year,12,31)
        TimeframeLog.create!(start_date: start_date,end_date: end_date,timeframe_id: timeframe_id,quarter: "Q4 " + timeframe_year.to_s)
      end
    end

end