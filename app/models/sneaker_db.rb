class SneakerDb < ApplicationRecord
  has_many :sneakers
  include PgSearch::Model
  pg_search_scope :search_by_name_category_and_price_cents,
    against: [ :name, :category, :price_cents ],
    using: {
      tsearch: { prefix: true } 
    }

end
