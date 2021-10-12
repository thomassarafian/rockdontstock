class Sneaker < ApplicationRecord
  include PgSearch::Model

	has_many_attached :photos, service: :cloudinary

  has_many :orders, dependent: :destroy
	belongs_to :user
  belongs_to :sneaker_db

	validates :size, presence: true
  validates :price, presence: true
  validates :condition, presence: true
  validates :box, presence: true

  monetize :price_cents


	# after_create :send_notification  # a configurer avec mailjet 

  pg_search_scope :search_by_name_and_brand,
    against: [:name],
    associated_against: {
      sneaker_db: [:name, :category]
    },
    using: {
      tsearch: { prefix: true } 
    }

  scope :filter_by_price, -> (price) { 
    if price == "100"
      Sneaker.where(price_cents: 0..10000)
    elsif price == "200"
      Sneaker.where(price_cents: 0..20000)
    elsif price == "300"
      Sneaker.where(price_cents: 0..30000)
    elsif price == "301"
     Sneaker.where(price_cents: 30000..10000000)
    end
  }

  scope :filter_by_category, -> (category) { 
    joins(:sneaker_db).where(:sneaker_dbs => { :category => category })
  }

  scope :filter_by_condition, -> (condition) { 
    where("sneakers.condition = ?", condition) 
  }
  
  # scope :filter_by_release_date, -> (release_date) { 
  #   if release_date == "2001"
  #     where("extract(year from release_date) >= ? and extract(year from release_date) <= ?", "1900", "2001")
  #   else
  #     where('extract(year from release_date) = ?', release_date) 
  #   end
  # }
  
  scope :filter_by_size, -> (size) {
    where("sneakers.size = ?", size)
 }


	def send_notification
    UserMailer.new_sneaker(self, user).deliver
  end



end
