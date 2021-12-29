class Forest::Sneaker
  include ForestLiana::Collection

  collection :Sneaker

  action "Set as home selection"
  action "Set as day selection", type: "single"
  action "Validate announcement"
  action "Reject announcement fake sneakers"
  action "Reject announcement bad criteria"
  action "Reject announcement bad angles"
  action "Validate announcement bad photos"
  action "Missing information"
end