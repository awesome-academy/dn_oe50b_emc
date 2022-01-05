namespace :weekly_announcement do
  desc "test"
  task test: :environment do
    Notificationad.create(event: "Vui lòng kiểm tra và duyệt các đơn hàng")
    puts "success"
  end
end
