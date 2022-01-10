class Notificationad < ApplicationRecord
  scope :total_unread, ->{where(read_at: nil).size}

  after_create_commit { NotificationBroadcastJob.perform_later(Notificationad.count,self)}
end
