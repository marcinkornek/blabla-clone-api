class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.integer :sender_id
      t.integer :receiver_id
      t.integer :ride_id
      t.integer :ride_request_id
      t.string :notification_type
      t.datetime :seen_at

      t.timestamps
    end
  end
end
