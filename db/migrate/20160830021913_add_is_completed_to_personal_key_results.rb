class AddIsCompletedToPersonalKeyResults < ActiveRecord::Migration[5.0]
  def change

    add_column :personal_key_results, :is_completed, :boolean

  end
end
