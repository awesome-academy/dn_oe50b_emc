import consumer from "./consumer"

consumer.subscriptions.create("NotificationadsChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    $('#notificationLists').prepend(data.notification)
    $('#open_notification').html(data.counter)
  }
});
