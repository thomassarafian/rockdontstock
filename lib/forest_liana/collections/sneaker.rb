class Forest::Sneaker
  include ForestLiana::Collection

  collection :Sneaker
  
  action "Validate announcement"
  action "Reject announcement bad criteria"
  action "Reject announcement bad quality img"
end
