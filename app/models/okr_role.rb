class OkrRole < ActiveRecord::Base

    # ---------
    # Relations
    # ---------

    has_and_belongs_to_many :users

    # -----------
    # Validations
    # -----------

    validates   :name, presence: true, length: { minimum: 2 }

end
