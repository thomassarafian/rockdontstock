class SneakerDb < ApplicationRecord
  has_many :sneakers, dependent: :destroy
  validates :name, uniqueness: true

  before_create :set_default_image

  include PgSearch::Model
  pg_search_scope :pg_search_by_name,
    against: [:name],
    using: {
      tsearch: { prefix: true } 
    }

  def self.search_by_name(query)
    if query.present?
      pg_search_by_name(query)
    else
      SneakerDb.all
    end
  end

  private

  def set_default_image
    self.img_url = "/assets/oeil-rds.png"
  end

 #  scope :filter_by_price, -> (price) { 
 #    if price == "100"
 #      where(price_cents: 0..100)
 #    elsif price == "200"
 #      where(price_cents: 0..200)
 #    elsif price == "300"
 #      where(price_cents: 0..300)
 #    elsif price == "301"
 #      where(price_cents: 300..100000)
 #    end
 #  }
 #  scope :filter_by_category, -> (category) { where category: category }
 #  scope :filter_by_condition, -> (condition) { 
 #    joins(:sneakers).where("sneakers.condition = ?", condition) 
 #  }
  
 #  # scope :filter_by_release_date, -> (release_date) { 
 #  #   if release_date == "2001"
 #  #     where("extract(year from release_date) >= ? and extract(year from release_date) <= ?", "1900", "2001")
 #  #   else
 #  #     where('extract(year from release_date) = ?', release_date) 
 #  #   end
 #  # }
  
 #  scope :filter_by_size, -> (size) {
 #    joins(:sneakers).where("sneakers.size = ?", size)
 # }

end
