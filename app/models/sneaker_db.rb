class SneakerDb < ApplicationRecord
  has_many :sneakers
  has_many :subcategories
  include PgSearch::Model
  pg_search_scope :search_by_name_category_sub_and_price,
    against: [:name, :category, :subcategory, :price_cents],
    using: {
      tsearch: { prefix: true } 
    }

  scope :filter_by_price, -> (price) { 
    if price == "100"
      where(price_cents: 0..100)
    elsif price == "200"
      where(price_cents: 0..200)
    elsif price == "300"
      where(price_cents: 0..300)
    elsif price == "301"
      where(price_cents: 300..100000)
    end
  }
  scope :filter_by_category, -> (category) { where category: category }
  scope :filter_by_release_date, -> (release_date) { 
    if release_date == "2001"
      where("extract(year from release_date) >= ? and extract(year from release_date) <= ?", "1900", "2001")
    else
      where('extract(year from release_date) = ?', release_date) 
    end
  }
  
  scope :filter_by_size, -> (size) {
    joins(:sneakers).where("sneakers.size = ?", size)
 }

end
