class FixColumnNameForUser < ActiveRecord::Migration[5.0]
  def change
    rename_column   :users, :name, :last_name
    add_column      :users, :first_name, :string
  end
end
