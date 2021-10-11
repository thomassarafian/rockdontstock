class Forest::Order
  include ForestLiana::Collection

  collection :Order
  
  action "Cancel sale in 24h"
  action "Cancel sale after 48h"
  action "Seller send package"
  action "Package received by rds"
  action "Sneaker legit"

end