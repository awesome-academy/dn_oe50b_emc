class Notification < ApplicationRecord
  belongs_to :recipient, class_name: "User"
  belongs_to :actor, class_name: "User"
  scope :unread, ->{where(read_at: nil).size}
  scope :sort_by_created, ->{order(created_at: :desc)}
end
