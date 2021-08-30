require 'csv'

# Order.destroy_all
# Sneaker.destroy_all
SneakerDb.destroy_all

# air_jordan_csv_file = File.read(Rails.root.join('lib', 'seeds', 'air_jordan.csv'))
# air_jordan_csv = CSV.parse(air_jordan_csv_file, :headers => true, :encoding => 'ISO-8859-1')

# new_balance_csv_file = File.read(Rails.root.join('lib', 'seeds', 'new_balance.csv'))
# new_balance_csv = CSV.parse(new_balance_csv_file, :headers => true, :encoding => 'ISO-8859-1')

# adidas_csv_file = File.read(Rails.root.join('lib', 'seeds', 'adidas.csv'))
# adidas_csv = CSV.parse(adidas_csv_file, :headers => true, :encoding => 'ISO-8859-1')

# nike_csv_file = File.read(Rails.root.join('lib', 'seeds', 'nike.csv'))
# nike_csv = CSV.parse(nike_csv_file, :headers => true, :encoding => 'ISO-8859-1')

all_sneakers_filtered = File.read(Rails.root.join('lib', 'seeds', 'all_sneakers_filtered.csv'))
all_sneakers_csv = CSV.parse(all_sneakers_filtered, :headers => true, :encoding => 'ISO-8859-1')


count = 0

all_sneakers_csv.each do |row|
  next if row['sneaker-title'] == "null" || row['sneaker-title'] == ""
  next if row['sneaker-title'].include? "page" 
  next if row['sneaker-title'].include? "Page"

  s = SneakerDb.find_or_initialize_by(name: row['sneaker-title'])
  # SneakerDb.new
  # s.subcategory = row['subcategory']
  # s.style = row['style']
  # s.coloris = row['coloris']
  #  if row['price-retail'] == "null" || row['price-retail'] == "--" 
  #   s.price_cents = '0'
  #  else
  #   s.price_cents = row['price-retail']     
  # end
  #  s.release_date = row['release-date']
    
  # s.name = row['sneaker-title']
  s.category = row['brand']

  if row['img-fixed-src'] == nil
    s.img_url = row['img-slide-src']
  elsif row['img-slide-src'] == nil
    if row['img-fixed-src'].start_with? "https://stockx-assets.imgix.net"
      s.img_url = '/assets/oeil-rds.png'
    else
      s.img_url = row['img-fixed-src']
    end
  else
    s.img_url = row['img-fixed-src']
  end
  if s.save
    count += 1
    puts "#{s.name} - #{count}"
  end
end




# air_jordan_csv.each do |row|
#   next if row['sneaker-title'] == "null" || row['sneaker-title'] == ""
#   next if row['sneaker-title'].include? "page"

#   s = SneakerDb.new
#   # s.subcategory = row['subcategory']
#   # s.style = row['style']
#   # s.coloris = row['coloris']
#   #  if row['price-retail'] == "null" || row['price-retail'] == "--" 
#   #  	s.price_cents = '0'
#   #  else
# 	# 	s.price_cents = row['price-retail']  		
# 	# end
#   #  s.release_date = row['release-date']
  
#   s.name = row['sneaker-title']
#   s.category = "Air Jordan"

#   if row['img-fixed-src'] == nil
#     s.img_url = row['img-slide-src']
#   elsif row['img-slide-src'] == nil
#     if row['img-fixed-src'].start_with? "https://stockx-assets.imgix.net"
#       s.img_url = '/assets/oeil-rds.png'
#     else
#       s.img_url = row['img-fixed-src']
#     end
#   else
#     s.img_url = row['img-fixed-src']
#   end
#   if s.save
#   	count += 1
# 		puts "#{s.name} - #{count}"
# 	end
# end

# new_balance_csv.each do |row|
#   s = SneakerDb.new
#   s.name = row['sneaker-title']
#   s.category = "New Balance"

#   if row['img-fixed-src'] == nil
#     s.img_url = row['img-slide-src']
#   elsif row['img-slide-src'] == nil
#     if row['img-fixed-src'].start_with? "https://stockx-assets.imgix.net"
#       s.img_url = '/assets/oeil-rds.png'
#     else
#       s.img_url = row['img-fixed-src']
#     end
#   else
#     s.img_url = row['img-fixed-src']
#   end
#   if s.save
#     count += 1
#     puts "#{s.name} - #{count}"
#   end
# end

# adidas_csv.each do |row|
#   next if row['sneaker-title'] == "null" || row['sneaker-title'] == ""
#   next if row['sneaker-title'].include? "page"
#   s = SneakerDb.new
#   s.name = row['sneaker-title']
#   s.category = "Adidas"
  
#   if row['img-fixed-src'] == nil
#     s.img_url = row['img-slide-src']
#   elsif row['img-slide-src'] == nil
#     if row['img-fixed-src'].start_with? "https://stockx-assets.imgix.net"
#       s.img_url = '/assets/oeil-rds.png'
#     else
#       s.img_url = row['img-fixed-src']
#     end
#   else
#     s.img_url = row['img-fixed-src']
#   end
#   if s.save
#     count += 1
#     puts "#{s.name} - #{count}"
#   end
# end

# nike_csv.each do |row|
#   next if row['sneaker-title'] == "null" || row['sneaker-title'] == ""
#   next if row['sneaker-title'].include? "page"
#   s = SneakerDb.new
#   s.name = row['sneaker-title']
#   s.category = "Nike"
#   if row['img-fixed-src'] == nil
#     s.img_url = row['img-slide-src']
#   elsif row['img-slide-src'] == nil
#     if row['img-fixed-src'].start_with? "https://stockx-assets.imgix.net"
#       s.img_url = '/assets/oeil-rds.png'
#     else
#       s.img_url = row['img-fixed-src']
#     end
#   else
#     s.img_url = row['img-fixed-src']
#   end
#   if s.save
#     count += 1
#     puts "#{s.name} - #{count}"
#   end
# end

