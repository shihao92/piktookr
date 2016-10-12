class LogPersonalKeyResult < ApplicationRecord

    # ---------
    # Relations
    # ---------

    belongs_to      :personal_key_result
    belongs_to      :user

    # -----------
    # Validations
    # -----------

    validates   :log_content, presence: true
    validates   :personal_key_result_id, presence: true, :numericality => { only_integer: true }
    validates   :user_id, presence: true, :numericality => { only_integer: true }


    def self.log_new_personal_key_result(key_result_id, objective, user_id)
      personal_key_result = PersonalKeyResult.find(key_result_id)
      log_content = 'Created <span class="bold">' + personal_key_result.key_result + '</span> and aligned with <span class="bold">' + objective + '</span>'
      save_new_log(log_content, key_result_id, user_id)
    end

    def self.log_update_progress_key_result(key_result_id, progress_difference, user_id)
      log_content = 'Contributed <span class="bold">+' + progress_difference.to_s + '%</span>'
      new_log_id = save_new_log(log_content, key_result_id, user_id)
      return new_log_id
    end

    def self.log_update_status_key_result(key_result_id, user_id)
      log_content = "Marked this key result as completed."
      new_log_id = save_new_log(log_content, key_result_id, user_id)
    end

    def self.log_rename_personal_key_result(original_key_result, edited_key_result, key_result_id, user_id)
      log_content = 'Renamed <del>' + original_key_result + '</del> to <span class="bold">' + edited_key_result + '</span>'
      save_new_log(log_content, key_result_id, user_id)
    end

    def self.remove_log_completed_key_result(key_result_id)
      LogPersonalKeyResult.where(log_content: "Marked this key result as completed.", personal_key_result_id: key_result_id).destroy_all()
    end

    def self.save_new_log(log_content, key_result_id, user_id)
      new_log = LogPersonalKeyResult.new(log_content: log_content, personal_key_result_id: key_result_id, user_id: user_id)
      # Return log id for the reference of the contribution for the progress increment 
      if new_log.save
        return new_log.id
      end
    end

    def self.retrieve_contribution(key_result_id)
      log_content = LogPersonalKeyResult.select("log_content, created_at").where('personal_key_result_id = ? and log_content like ?', key_result_id, 'Contributed%').limit(5)
      return log_content
    end

end
