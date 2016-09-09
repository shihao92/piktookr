class AddUserToTeamKeyResults < ActiveRecord::Migration[5.0]
  def change
    add_reference :team_key_results, :user, foreign_key: true
  end
end
