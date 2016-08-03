class CreateContributions < ActiveRecord::Migration[5.0]
  def change
    create_table :contributions do |t|
      t.string        :contribution_comment
      t.references    :personal_key_result, foreign_key: true
      t.timestamps
    end
  end
end
