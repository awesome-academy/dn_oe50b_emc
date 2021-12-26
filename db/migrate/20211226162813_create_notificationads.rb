class CreateNotificationads < ActiveRecord::Migration[6.1]
  def change
    create_table :notificationads do |t|
      t.string :event

      t.timestamps
    end
  end
end
