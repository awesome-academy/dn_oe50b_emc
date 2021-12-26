class Notificationad < ApplicationRecord
  scope :total_unread, ->{where(read_at: nil).size}
end
