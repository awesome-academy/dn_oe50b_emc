class Notificationad < ApplicationRecord
  after_create_commit do
    NotificationadBroadcastJob.perform_later(Notificationad.total_unread, self)
  end

  scope :total_unread, ->{where(read_at: nil).size}
end
