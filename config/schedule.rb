set :output, "log/cron.log"

every 1.week do
  rake "cleanup:sneakers"
end