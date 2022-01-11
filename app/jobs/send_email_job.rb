class SendEmailJob < ApplicationJob
  queue_as :default

  def perform order
    OrderMailer.new_orders(order).deliver_now
  end
end
