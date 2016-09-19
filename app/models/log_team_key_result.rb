class LogTeamKeyResult < ApplicationRecord

    belongs_to      :team_key_result
    belongs_to      :user

    def self.log_new_team_key_result(key_result_id, team_objective, user_id)
      team_key_result = TeamKeyResult.find(key_result_id)
      log_content = 'Created <span class="bold">' + team_key_result.key_result + '</span> and aligned with <span class="bold">' + team_objective + '</span>'
      save_new_log(log_content, key_result_id, user_id)
    end

    def self.log_update_progress_key_result(personal_key_result, key_result_id, progress_difference, user_id)    
      log_content = 'Contributed <span class="bold">+' + ('%.02f' % progress_difference).to_s + '%</span> via <p class="bold">' + personal_key_result + '</p>'
      save_new_log(log_content, key_result_id, user_id)
    end

    def self.log_rename_team_key_result(original_key_result, edited_key_result, key_result_id, user_id)
      log_content = 'Renamed <del>' + original_key_result + '</del> to <span class="bold">' + edited_key_result + '</span>'
      save_new_log(log_content, key_result_id, user_id)
    end

    def self.save_new_log(log_content, key_result_id, user_id)
      new_log = LogTeamKeyResult.new(log_content: log_content, team_key_result_id: key_result_id, user_id: user_id)
      new_log.save
    end

end
