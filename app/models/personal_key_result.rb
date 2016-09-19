class PersonalKeyResult < ApplicationRecord

    belongs_to      :personal_objective
    has_many        :contributions
    accepts_nested_attributes_for :contributions

    has_many        :log_personal_key_results
    accepts_nested_attributes_for :log_personal_key_results

    def self.new_personal_key_result(key_result, objective_id, user_id)
      status = 0
      personal_objective = PersonalObjective.find(objective_id)
      @new_personal_key_result = PersonalKeyResult.new(
        progress: 0.0, 
        key_result: key_result, 
        personal_objective_id: objective_id
      )
      if @new_personal_key_result.save
        LogPersonalKeyResult.log_new_personal_key_result(@new_personal_key_result.id, personal_objective.objective, user_id)    
        cascade_personal_objective("", objective_id, 0)
        status = 200
      else
        status = 0
      end

      return status
    end

    def self.update_progress_personal_key_result(key_result_id, progress, initial_progress, contribution, user_id)
      status = 0
      progress_difference = progress - initial_progress
      personal_key_result = PersonalKeyResult.find(key_result_id)
      # If user_id is 0, system is updating the progress of the OKR that had been newly created.
      # Therefore, no log is required to be generated when update progress.
      if user_id != 0
        if PersonalKeyResult.where(id: key_result_id).update_all(progress: progress)   
          # Log generated for personal key result
          # No log required if the new key result is being created
          generated_log_id = LogPersonalKeyResult.log_update_progress_key_result(key_result_id, progress_difference, user_id) 

          # Save new contribution for this personal key result progress increment
          new_contribution = Contribution.new(
            contribution_comment: contribution, 
            personal_key_result_id: key_result_id, 
            log_personal_key_result_id: generated_log_id
          )
          if new_contribution.save 
            cascade_personal_objective(
              personal_key_result.key_result, 
              personal_key_result.personal_objective_id, 
              user_id
              )
            status = 200
          end                
        end
      else
        # For updating the progress of other OKR hierarchy when create operation is done
        # Cascade to Personal Objective
        cascade_personal_objective(
          "", 
          personal_key_result.personal_objective_id,  
          user_id
        )
        status = 200
      end

      return status
    end

    def self.update_status_personal_key_result(key_result_id, objective_id, completed_flag, user_id)
      status = 0
      if PersonalKeyResult.where(id: key_result_id).update_all(is_completed: completed_flag)
        if completed_flag == "true"
          # Update progress starting from personal objective onwards
          # Status update for the personal key result does not require contribution input
          cascade_personal_objective("", objective_id, user_id)
          # Only completed key result will be logged
          LogPersonalKeyResult.log_update_status_key_result(key_result_id, user_id)
        else
          personal_key_result = PersonalKeyResult.find(key_result_id)
          cascade_personal_objective("", objective_id, 0)
          # Remove all marked completed log
          LogPersonalKeyResult.remove_log_completed_key_result(key_result_id)
        end
        status = 200
      end

      return status
    end

    def self.rename_personal_key_result(original_key_result, edited_key_result, key_result_id, user_id)
      status = 0
      if PersonalKeyResult.where(id: key_result_id).update_all(key_result: edited_key_result)
        LogPersonalKeyResult.log_rename_personal_key_result(original_key_result, edited_key_result, key_result_id, user_id)
        status = 200
      end
      return status
    end

    def self.delete_personal_key_result(personal_key_result)
      status = 0
      Contribution.where(personal_key_result_id: personal_key_result.id).destroy_all()
      LogPersonalObjective.log_delete_personal_key_result(personal_key_result.id)
      LogPersonalKeyResult.where(personal_key_result_id: personal_key_result.id).destroy_all()
      if personal_key_result.destroy
        cascade_personal_objective("", personal_key_result.personal_objective_id, 0)
        status = 200
      end
      return status
    end

    def self.cascade_personal_objective(key_result, objective_id, user_id)
      status = 0
      # Cascade to Personal Objective
      personal_key_results = PersonalKeyResult.where(personal_objective_id: objective_id)
      total_progress = 0.00
      item_count = 0
      personal_key_results.each do |item|
        if item.is_completed != true
          total_progress = total_progress + item.progress
          item_count = item_count + 1
        end   
      end
      if item_count == 0
        item_count = 1
      end
      progress_contribution = calculate_progress_contribution(total_progress, item_count)
      PersonalObjective.update_progress_objective(
        key_result,
        objective_id, 
        progress_contribution, 
        user_id
      )
      status = 200

      return status
    end

    def self.calculate_progress_contribution(progress, count) 
      progress_contribution = progress / count
      progress_contribution = progress_contribution.round(2)
      return progress_contribution
    end

end
