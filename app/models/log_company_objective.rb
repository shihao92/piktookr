class LogCompanyObjective < ApplicationRecord

    # ---------
    # Relations
    # ---------

    belongs_to      :company_objective
    belongs_to      :user

    # -----------
    # Validations
    # -----------

    validates   :log_content, presence: true
    validates   :company_objective_id, presence: true, :numericality => { only_integer: true }
    validates   :user_id, presence: true, :numericality => { only_integer: true }


    def self.log_new_company_objective(objective, objective_id, user_id)
      log_content = 'Created <span class="bold">' + objective + '</span>' 
      save_new_log(log_content, objective_id, user_id)
    end

    def self.log_update_progress_objective(personal_key_result, progress, objective_id, user_id)
      log_content = 'Contributed <span class="bold">+' + ('%.02f' % progress).to_s + '%</span> via <p class="bold">' + personal_key_result + '</p>'
      save_new_log(log_content, objective_id, user_id)
    end

    def self.log_rename_company_objective(original_objective, edited_objective, objective_id, user_id) 
      log_content = 'Renamed <del>' + original_objective + '</del> to <span class="bold">' + edited_objective + '</span>' 
      save_new_log(log_content, objective_id, user_id)
    end

    def self.log_delete_company_key_result(key_result, objective_id, user_id)
      log_content = 'Deleted <span><del>' + key_result + '</del></span>'
      save_new_log(log_content, objective_id, user_id)
    end

    def self.save_new_log(log_content, objective_id, user_id)
      new_log = LogCompanyObjective.new(log_content: log_content, company_objective_id: objective_id, user_id: user_id)
      new_log.save
    end 

end
