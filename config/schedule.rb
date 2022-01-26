set :output, "log/cron.log"

every 2.week do
  rake "cleanup:sneakers"
end