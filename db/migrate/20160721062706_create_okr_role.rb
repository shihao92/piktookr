class CreateOkrRole < ActiveRecord::Migration[5.0]
  def change
    create_table :okr_roles do |t|
      t.string :name
      t.string :description
    end
  end
end
