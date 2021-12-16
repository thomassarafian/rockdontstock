namespace :cleanup do
  desc "removes stale sneakers from db"
  task sneakers: :environment do
    stale_sneakers = Sneaker.where("DATE(created_at) < DATE(?)", Date.yesterday).where.not(status: "active").or(Sneaker.where(status: nil))
    stale_sneakers.map(&:destroy)
  end
end
