class SneakerDb < ApplicationRecord
  has_many :sneakers
  include PgSearch::Model
  pg_search_scope :search_by_name_and_category,
    against: [ :name, :category ],
    using: {
      tsearch: { prefix: true } 
    }

end
