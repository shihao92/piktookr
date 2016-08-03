class CompanyObjective < ApplicationRecord

    belongs_to  :timeframe_log
    has_many    :company_key_results
    
end
