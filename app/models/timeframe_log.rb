class TimeframeLog < ApplicationRecord

    has_one :timeframe
    has_many :company_objectives

end