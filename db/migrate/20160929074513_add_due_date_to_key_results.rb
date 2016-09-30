class AddDueDateToKeyResults < ActiveRecord::Migration[5.0]
  def change
    add_column      :personal_key_results, :due_date, :date
    add_column      :team_key_results, :due_date, :date
    add_column      :company_key_results, :due_date, :date
  end
end
