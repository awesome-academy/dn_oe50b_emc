class AddContentToNotifications < ActiveRecord::Migration[6.1]
  def change
    add_column :notifications, :content, :string
  end
end
