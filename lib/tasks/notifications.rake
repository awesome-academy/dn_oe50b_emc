namespace :notifications do
  desc "send_noti"
  task send_noti: :environment do
    Notificationad.create(event: I18n.t("order.noti.statistic_order"))
  end
end
