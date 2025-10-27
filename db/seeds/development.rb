require 'csv'

Sneaker.destroy_all
SneakerDb.destroy_all
User.destroy_all

sneakers_db_csv_file = File.read(Rails.root.join('lib', 'seeds', 'sneakers_db.csv'))
sneakers_db_csv = CSV.parse(sneakers_db_csv_file, :headers => true, :encoding => 'ISO-8859-1')

count = 0

user_1 = User.create(
  email: 'john.dupont@gmail.com',
  password: 'Abc123456',
  password_confirmation: 'Abc123456',
  first_name: 'John',
  last_name: 'Dupont',
  phone: '0606060606',
  line1: '123 Rue de la Paix',
  city: 'Paris',
  postal_code: '75001',
  date_of_birth: '1990-01-01',
  iban: 'FR1420041010050500013M02606'
)

sneakers_db_csv.each do |row|
  s = SneakerDb.find_or_initialize_by(name: row['sneaker-title'])
  s.name = row['sneaker-title']
  s.img_url = row['img_url']

  if s.save
    count += 1
    puts "#{s.name} - #{count}"
  end
end

# Sneaker 1: Nike Air Max 95 Lux Supreme Blue
sneaker_1 = Sneaker.create(
  name: 'Nike Air Max 95 Lux Supreme Blue',
  size: 42,
  condition: 8,
  box: "Boîte d'origine (sans extra)",
  user: user_1,
  price_cents: 22000,
  state: 1,
  sneaker_db: SneakerDb.find_by(name: 'Nike Air Max 95 Lux Supreme Blue'),
  status: "Mise en ligne"
)

# Attach images from local files using Active Storage
(1..8).each do |num|
  file_path = Rails.root.join('app', 'assets', 'images', 'seeds', 'nike-supreme-air-max-95-italian-leather-blue', "#{num}.webp")
  file = File.open(file_path)
  sneaker_1.photos.attach(
    io: file,
    filename: "nike_air_max_95_lux_supreme_blue_#{num}.webp",
    content_type: 'image/webp'
  )
end

# Sneaker 2: Hoka One One Mafate Speed 2 White Lunar Rock (All Gender)
sneaker_2 = Sneaker.create(
  name: 'Hoka One One Mafate Speed 2 White Lunar Rock (All Gender)',
  size: 41,
  condition: 9,
  box: "Boîte d'origine avec extra",
  user: user_1,
  price_cents: 18000,
  state: 1,
  sneaker_db: SneakerDb.find_by(name: 'Hoka One One Mafate Speed 2 White Lunar Rock (All Gender)'),
  status: "Mise en ligne"
)

# Attach images from local files using Active Storage
(1..8).each do |num|
  file_path = Rails.root.join('app', 'assets', 'images', 'seeds', 'hoka-mafate-speed-2', "#{num}.webp")
  file = File.open(file_path)
  sneaker_2.photos.attach(
    io: file,
    filename: "hoka_mafate_speed_2_running_shoes_#{num}.webp",
    content_type: 'image/webp'
  )
end

# Sneaker 3: Travis Scott x Jordan Air Jordan 1 Low Golf
sneaker_3 = Sneaker.create(
  name: 'Travis Scott x Jordan Air Jordan 1 Low Golf',
  size: 43,
  condition: 7,
  box: "Boîte d'origine (sans extra)",
  user: user_1,
  price_cents: 25000,
  state: 1,
  sneaker_db: SneakerDb.find_by(name: 'Travis Scott x Jordan Air Jordan 1 Low Golf'),
  status: "Mise en ligne"
)

# Attach images from local files using Active Storage
(1..8).each do |num|
  file_path = Rails.root.join('app', 'assets', 'images', 'seeds', 'travis-scott-air-jordan-1-low-golf', "#{num}.webp")
  file = File.open(file_path)
  sneaker_3.photos.attach(
    io: file,
    filename: "travis_scott_x_jordan_air_jordan_1_low_golf_#{num}.webp",
    content_type: 'image/webp'
  )
end

puts "Created 3 sneakers with local images!"
