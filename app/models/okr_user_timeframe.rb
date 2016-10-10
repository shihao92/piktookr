class OkrUserTimeframe < ApplicationRecord

    # ---------
    # Relations
    # ---------

    belongs_to :user
    belongs_to :timeframe_log

    # -----------
    # Validations
    # -----------

    validates   :user_id, presence: true, :numericality => { only_integer: true }
    validates   :timeframe_log_id, presence: true, :numericality => { only_integer: true }

end
