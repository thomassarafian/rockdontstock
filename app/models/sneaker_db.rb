class SneakerDb < ApplicationRecord
  has_many :sneakers
  include PgSearch::Model
  pg_search_scope :search_by_name_category_sub_and_price,
    against: [:name, :category, :subcategory, :price_cents],
    using: {
      tsearch: { prefix: true } 
    }

end
