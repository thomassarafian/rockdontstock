class Sneaker < ApplicationRecord
  include PgSearch::Model
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]
	# after_create :send_notification  # a configurer avec mailjet 
  
	has_many_attached :photos, service: :cloudinary, dependent: :detach
  has_many :orders, dependent: :destroy
	belongs_to :user
  belongs_to :sneaker_db, optional: true
  
  validates :sneaker_db, presence: true, if: :active_or_step_sneaker_db?
  validates :size, :condition, :box, :price, presence: true, if: :active_or_step_infos?
  validates :photos, presence: true, if: :active_or_step_photos?
  validates :legal1, :legal2, :legal3, acceptance: true

  accepts_nested_attributes_for :sneaker_db

  monetize :price_cents
  
  pg_search_scope :pg_search_by_name_and_brand,
  against: [:name],
  associated_against: { sneaker_db: [:name, :category] },
  using: { tsearch: { prefix: true } }

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
    where("sneakers.condition = ?", condition.to_i) 
  }
  scope :filter_by_size, -> (size) {
    where("sneakers.size = ?", size.to_d)
  }

  def self.search_by_name_and_brand(query)
    if query.present?
      pg_search_by_name_and_brand(query)
    else
      Sneaker.all
    end
  end

  def send_notification
    UserMailer.new_sneaker(self, user).deliver
  end

  def active?
    status == "active"
  end

  def active_or_step_sneaker_db?
    status&.include?("sneaker_db") || active?
  end

  def active_or_step_infos?
    status&.include?("infos") || active?
  end

  def active_or_step_photos?
    status&.include?("photos") || active?
  end

end
