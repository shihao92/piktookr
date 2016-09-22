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
      log = TimeframeLog.where("(start_date, end_date) OVERLAPS ('" + current_date + "'::DATE, '" + current_date + "'::DATE)");
      return log[0].id;
    end

end