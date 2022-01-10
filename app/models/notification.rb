class Notification < ApplicationRecord
  after_create_commit do
    NotificationBroadcastJob.perform_later(
      Notification.unread, self
    )
  end

  belongs_to :recipient, class_name: "User"
  belongs_to :actor, class_name: "User"
  scope :unread, ->{where(read_at: nil).size}
  scope :sort_by_created, ->{order(created_at: :desc)}
end
