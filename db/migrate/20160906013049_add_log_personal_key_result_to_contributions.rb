class AddLogPersonalKeyResultToContributions < ActiveRecord::Migration[5.0]
  def change
    add_reference :contributions, :log_personal_key_result, foreign_key: true
  end
end
