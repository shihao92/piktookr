class AddQuarterToTimeframeLog < ActiveRecord::Migration[5.0]
  def change
    add_column :timeframe_logs, :quarter, :string
  end
end
