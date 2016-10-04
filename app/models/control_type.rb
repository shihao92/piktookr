class ControlType < ApplicationRecord

  # ---------
  # Relations
  # ---------

  has_many      :controls

  # -----------
  # Validations
  # -----------

  validates     :okr_system_type, presence: true

end
