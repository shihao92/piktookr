class ChangeProgressFromCompanyObjectives < ActiveRecord::Migration[5.0]
  def change
    change_column :company_objectives, :progress, :decimal, precision: 5, scale: 2
  end
end
