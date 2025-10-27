# PRoduction file testing in development
require 'csv'
require 'open-uri'

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

# Attach Cloudinary images for sneaker 1
cloudinary_images_1 = [
  'https://res.cloudinary.com/dzv2ugno5/image/upload/v1761227402/1_pmn4od.webp',
  'https://res.cloudinary.com/dzv2ugno5/image/upload/v1761227402/2_f4oc6t.webp',
  'https://res.cloudinary.com/dzv2ugno5/image/upload/v1761227402/3_atjdxy.webp',
  'https://res.cloudinary.com/dzv2ugno5/image/upload/v1761227403/4_y8m7uo.webp',
  'https://res.cloudinary.com/dzv2ugno5/image/upload/v1761227403/5_scbdam.webp',
  'https://res.cloudinary.com/dzv2ugno5/image/upload/v1761227403/6_zzfm9q.webp',
  'https://res.cloudinary.com/dzv2ugno5/image/upload/v1761227403/7_cdcxbp.webp',
  'https://res.cloudinary.com/dzv2ugno5/image/upload/v1761227404/8_vmsms2.webp'
]

cloudinary_images_1.each_with_index do |url, index|
  file = URI.open(url)
  sneaker_1.photos.attach(
    io: file,
    filename: "nike_air_max_95_lux_supreme_blue_#{index + 1}.webp",
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

# Attach Cloudinary images for sneaker 2
cloudinary_images_2 = [
  'https://res.cloudinary.com/dzv2ugno5/image/upload/v1761227420/1_ywjzlv.webp',
  'https://res.cloudinary.com/dzv2ugno5/image/upload/v1761227421/2_jyowgk.webp',
  'https://res.cloudinary.com/dzv2ugno5/image/upload/v1761227421/3_h2w1nr.webp',
  'https://res.cloudinary.com/dzv2ugno5/image/upload/v1761227421/4_ng1sqn.webp',
  'https://res.cloudinary.com/dzv2ugno5/image/upload/v1761227422/5_dnqfg3.webp',
  'https://res.cloudinary.com/dzv2ugno5/image/upload/v1761227422/6_lq5s7u.webp',
  'https://res.cloudinary.com/dzv2ugno5/image/upload/v1761227423/7_loppt9.webp',
  'https://res.cloudinary.com/dzv2ugno5/image/upload/v1761227423/8_xa4yqc.webp'
]

cloudinary_images_2.each_with_index do |url, index|
  file = URI.open(url)
  sneaker_2.photos.attach(
    io: file,
    filename: "hoka_mafate_speed_2_running_shoes_#{index + 1}.webp",
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

# Attach Cloudinary images for sneaker 3
cloudinary_images_3 = [
  'https://res.cloudinary.com/dzv2ugno5/image/upload/v1761227434/1_ejta8g.webp',
  'https://res.cloudinary.com/dzv2ugno5/image/upload/v1761227435/2_eoafbu.webp',
  'https://res.cloudinary.com/dzv2ugno5/image/upload/v1761227435/3_z6ac0z.webp',
  'https://res.cloudinary.com/dzv2ugno5/image/upload/v1761227435/4_tixlph.webp',
  'https://res.cloudinary.com/dzv2ugno5/image/upload/v1761227436/5_vzujqe.webp',
  'https://res.cloudinary.com/dzv2ugno5/image/upload/v1761227437/6_bhhkq5.webp',
  'https://res.cloudinary.com/dzv2ugno5/image/upload/v1761227437/7_soeqeo.webp',
  'https://res.cloudinary.com/dzv2ugno5/image/upload/v1761227438/8_s0gtxv.webp'
]

cloudinary_images_3.each_with_index do |url, index|
  file = URI.open(url)
  sneaker_3.photos.attach(
    io: file,
    filename: "travis_scott_x_jordan_air_jordan_1_low_golf_#{index + 1}.webp",
    content_type: 'image/webp'
  )
end

puts "Created 3 sneakers with Cloudinary images!"