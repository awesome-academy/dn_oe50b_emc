class NotificationBroadcastJob < ApplicationJob
  queue_as :default
  after_create :send_notification

  def perform notification
    ActionCable.server.broadcast "notifications:#{notification.receiver_id}", counter: render_counter(notification.receiver.notifications.count), layout: render_notification(notification)
  end

  private

  def render_counter counter
    ApplicationController.renderer.render(partial: "notifications/counter", locals: {counter: counter})
  end

  def render_notification notification
    ApplicationController.renderer.render(partial: "notifications/notification", locals: {notification: notification})
  end

  def send_notification
  NotificationBroadcastJob.perform_now(self)
  end
end
