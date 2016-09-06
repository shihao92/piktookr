class CreateLogTeamKeyResults < ActiveRecord::Migration[5.0]
  def change
    create_table :log_team_key_results do |t|
      t.string      :log_content
      t.references  :team_key_result, foreign_key: true
      t.references  :user, foreign_key: true
      t.timestamps
    end
  end
end
