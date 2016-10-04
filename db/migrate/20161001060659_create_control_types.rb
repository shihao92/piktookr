class CreateControlTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :control_types do |t|
      t.string      :okr_system_type
      t.timestamps
    end
  end
end
