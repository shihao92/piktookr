class AddUserToTeamObjectives < ActiveRecord::Migration[5.0]
  def change
    add_reference :team_objectives, :users, foreign_key: true
  end
end
