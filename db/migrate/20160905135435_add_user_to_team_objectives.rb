class AddUserToTeamObjectives < ActiveRecord::Migration[5.0]
  def change
    add_reference :team_objectives, :user, foreign_key: true
  end
end
