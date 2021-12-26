class AddReadAtToNotificationads < ActiveRecord::Migration[6.1]
  def change
    add_column :notificationads, :read_at, :datetime
    add_column :notificationads, :order_id, :integer
  end
end
