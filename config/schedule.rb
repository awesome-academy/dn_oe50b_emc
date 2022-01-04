set :environment, "development"
set :output, "log/log_error.log"

every "* 7 28 * *" do
  rake "notifications:send_noti"
end
