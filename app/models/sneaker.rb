class Sneaker < ApplicationRecord
  include PgSearch::Model
  extend FriendlyId

  enum state: {
    "Paire Fake": -3,
    "Photos non conformes": -2,
    "Critères non conformes": -1,
    "Vérification des photos": 0, # DEFAULT
    "Mise en ligne": 1,
    "Paire vendue": 2,
    "En attente de reception par RDS": 3,
    "Legit check de ta paire": 4,
    "Ta paire est LEGIT": 5,
    "En cours d'envoi vers le client": 6,
  }

  friendly_id :name, use: [:slugged, :finders]

  before_save :timestamp_selection, if: -> { selected_changed? || highlighted_changed? }
  before_create -> { self.state = 0 }
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

  scope :highlighted, -> { where(highlighted: true).order(highlighted_at: :asc) }
  scope :selected, -> { where(selected: true).order(selected_at: :asc) }

  scope :filter_by_min_price, -> (min) {
    where("price_cents >= ?", min.to_i * 100)
  }
  scope :filter_by_max_price, -> (max) { 
    where("price_cents <= ?", max.to_i * 100)
  }
  scope :filter_by_category, -> (category) { 
    joins(:sneaker_db).where(:sneaker_dbs => { :category => category })
  }
  scope :filter_by_condition, -> (condition) { 
    where(condition: condition) 
  }
  scope :filter_by_size, -> (size) {
    where(size: size)
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
    status&.include?("sneaker_db_ok") || active?
  end

  def active_or_step_infos?
    status&.include?("infos_ok") || active?
  end

  def active_or_step_photos?
    status&.include?("photos_ok") || active?
  end

  def last_completed_step
    status&.gsub('_ok', '')
  end

  def timestamp_selection
    self.selected_at = Time.zone.now if self.selected_change&.last === true || self.selected_at.nil?
    self.highlighted_at = Time.zone.now if self.highlighted_change&.last === true || self.highlighted_at.nil?
  end

end
