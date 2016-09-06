class AddUserToCompanyObjectives < ActiveRecord::Migration[5.0]
  def change
    add_reference :company_objectives, :users, foreign_key: true
  end
end
