class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.string      :notification_message
      t.references  :sender, index: true
      t.references  :receiver, index: true
      t.timestamps
    end
  end
end
