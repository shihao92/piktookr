class Feedback < ApplicationRecord

  # ---------
  # Relations
  # ---------

  belongs_to      :user

  # -----------
  # Validations
  # -----------

  validates   :content, presence: true
  enum feedback_status: { recent: 0, seen: 1, replied: 2 }

end
