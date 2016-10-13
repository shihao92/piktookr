class LogCompanyKeyResult < ApplicationRecord

    # ---------
    # Relations
    # ---------

    belongs_to      :company_key_result
    belongs_to      :user

    # -----------
    # Validations
    # -----------

    validates   :log_content, presence: true
    validates   :company_key_result_id, presence: true, :numericality => { only_integer: true }
    validates   :user_id, presence: true, :numericality => { only_integer: true }


    def self.log_new_company_key_result(key_result_id, company_objective, user_id)
      company_key_result = CompanyKeyResult.find(key_result_id)
      log_content = 'Created <span class="bold">' + company_key_result.key_result + '</span> and aligned with <span class="bold">' + company_objective + '</span>'
      save_new_log(log_content, key_result_id, user_id)  
    end

    def self.log_update_progress_key_result(personal_key_result, key_result_id, progress_difference, user_id)    
      log_content = 'Contributed <span class="bold">+' + ('%.02f' % progress_difference).to_s + '%</span> via <p class="bold">' + personal_key_result + '</p>'
      save_new_log(log_content, key_result_id, user_id)
    end

    def self.log_rename_company_key_result(original_key_result, edited_key_result, key_result_id, user_id)
      log_content = 'Renamed <del>' + original_key_result + '</del> to <span class="bold">' + edited_key_result + '</span>'
      save_new_log(log_content, key_result_id, user_id)
    end

    def self.save_new_log(log_content, key_result_id, user_id)
      new_log = LogCompanyKeyResult.new(log_content: log_content, company_key_result_id: key_result_id, user_id: user_id)
      new_log.save
    end

    def self.retrieve_contribution(key_result_id)
      log_content = LogCompanyKeyResult.select("log_content, created_at").where('company_key_result_id = ? and log_content like ?', key_result_id, 'Contributed%').limit(5)
      return log_content
    end

end
