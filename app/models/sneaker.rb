class Sneaker < ApplicationRecord
  include PgSearch::Model

	has_many_attached :photos, dependent: :destroy

  has_many :orders, dependent: :destroy
	belongs_to :user
  belongs_to :sneaker_db

	validates :size, presence: true
  validates :price, presence: true
  validates :condition, presence: true
  validates :box, presence: true

  # validate :photos, if: :photos_limit_min
  monetize :price_cents


	# after_create :send_notification  # a configurer avec mailjet 


  pg_search_scope :search_by_name,
    against: [:name],
    associated_against: {
      sneaker_db: [:name]
    },
    using: {
      tsearch: { prefix: true } 
    }

  scope :filter_by_price, -> (price) { 
    if price == "100"
      where(price_cents: 0..10000)
    elsif price == "200"
      where(price_cents: 0..20000)
    elsif price == "300"
      where(price_cents: 0..30000)
    elsif price == "301"
      where(price_cents: 300..10000000)
    end
  }

  scope :filter_by_category, -> (category) { 
    puts category
    puts category
    puts category
    puts category
    Sneaker.joins(:sneaker_db).where(:sneaker_dbs => { :category => category })

    # where("sneaker_db.category = ?", category)
    # joins(:sneaker_db).where("sneaker_db.category = ?", category )
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

  private    
  
  def photos_limit_min
    # return false if self.photos.empty?
    errors.add(:photos, " You must to upload at least 7 images") if self.photos.length <= 7 || self.photos.empty?
    # errors.add(:photos, " You must to upload at least 7 images") if self.photos.length <= 7
    return false
  end

end
