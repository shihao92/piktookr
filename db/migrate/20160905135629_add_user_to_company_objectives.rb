class AddUserToCompanyObjectives < ActiveRecord::Migration[5.0]
  def change
    add_reference :company_objectives, :user, foreign_key: true
  end
end
