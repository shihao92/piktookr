class LogPersonalObjective < ApplicationRecord

    # ---------
    # Relations
    # ---------

    belongs_to      :personal_objective
    belongs_to      :user

    # -----------
    # Validations
    # -----------

    validates   :log_content, presence: true
    validates   :personal_objective_id, presence: true, :numericality => { only_integer: true }
    validates   :user_id, presence: true, :numericality => { only_integer: true }


    def self.log_new_personal_objective(objective, objective_id, team_key_result, user_id)
      log_content = 'Created <span class="bold">' + objective + '</span> and aligned with <span class="bold">' + team_key_result + '</span>'
      save_new_log(log_content, objective_id, user_id)
    end

    def self.log_update_progress_objective(personal_key_result, personal_key_result_id, progress, objective_id, user_id)
      log_content = 'Contributed <span class="bold">+' + ('%.02f' % progress).to_s + '%</span> via <a href="/personal_key_results/' + personal_key_result_id.to_s + '/details" class="bold">' + personal_key_result + '</a>'
      save_new_log(log_content, objective_id, user_id) 
    end

    def self.log_rename_personal_objective(original_objective, edited_objective, objective_id, user_id)
      log_content = 'Renamed <del>' + original_objective + '</del> to <span class="bold">' + edited_objective + '</span>'
      save_new_log(log_content, objective_id, user_id)
    end

    def self.log_delete_personal_key_result(key_result_id)
      personal_key_result = PersonalKeyResult.find(key_result_id)
      personal_objective = PersonalObjective.find(personal_key_result.personal_objective_id)
      log_content = 'Deleted <span><del>' + personal_key_result.key_result + '</del></span>'
      save_new_log(log_content, personal_key_result.personal_objective_id, personal_objective.user_id)
    end

    def self.save_new_log(log_content, objective_id, user_id)
      new_log = LogPersonalObjective.new(log_content: log_content, personal_objective_id: objective_id, user_id: user_id)
      new_log.save
    end

    def self.retrieve_contribution(objective_id)
      log_content = LogPersonalObjective.select("log_content, created_at").where('personal_objective_id = ? and log_content like ?', objective_id, 'Contributed%').limit(5)
      return log_content
    end

end
