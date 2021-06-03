require 'csv'

Order.destroy_all
Sneaker.destroy_all
SneakerDb.destroy_all

csv_text = File.read(Rails.root.join('lib', 'seeds', 'air_jordan.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')





count = 0
csv.each do |row|
  next if row['sneaker-title'] == "null" || row['sneaker-title'] == ""
  s = SneakerDb.new
  s.name = row['sneaker-title']
  s.style = row['style']
  s.style = row['style']
  s.coloris = row['coloris']
  
  if row['price-retail'] == "null" || row['price-retail'] == "--" 
  	puts row
  	s.price_cents = '0'
  else
		s.price_cents = row['price-retail']  		
	end

  s.release_date = row['release-date']
  s.category = "Air Jordan"
  if row['img-fixed-src'] == nil
  	s.img_url = row['img-slide-src']
  elsif row['img-slide-src'] == nil
  	s.img_url = row['img-fixed-src']
  end
  

  if s.save
  	count += 1
		puts count
	end
end






# Sneaker.create(name: "Jordan 12 Retro Low Easter (2021)", size: 44, price: 200, condition: 5, box: "OG Box", extras: "lacets", state: 1, user_id: 1)
# Sneaker.create(name: "Jordan 5 Retro White Stealth (2021)", size: 42, price: 125, condition: 8, box: "OG Box", extras: "lacets", state: 1, user_id: 1)

 
 #  Sneaker.create(name: "adidas Yeezy 700 V3 Kyanite", size: 38, price: 149, condition: 10, box: "OG Box", extras: "lacets", user_id: 2)
	# Sneaker.create(name: "Nike Air Max 720 Slip OBJ Black", size: 44, price: 199, condition: 5, box: "OG Box", extras: "lacets", user_id: 2)
 
 #  Sneaker.create(name: "Jordan 1 Retro High White University Blue Black", size: 42, price: 125, condition: 8, box: "OG Box", extras: "lacets", user_id: 2) 
 #  Sneaker.create(name: "adidas Yeezy Boost 350 V2 Ash Pearl", size: 38, price: 149, condition: 10, box: "OG Box", extras: "lacets", user_id: 2)
	
	# Sneaker.create(name: "Jordan 5 Retro Raging Bulls Red (2021)", size: 44, price: 199, condition: 5, box: "OG Box", extras: "lacets", user_id: 2)
 #  Sneaker.create(name: "Jordan 6 Retro Carmine (2021)", size: 42, price: 125, condition: 8, box: "OG Box", extras: "lacets", user_id: 2)
  
 #  Sneaker.create(name: "adidas Yeezy Foam RNNR Sand", size: 38, price: 149, condition: 10, box: "OG Box", extras: "lacets", user_id: 2)
	# Sneaker.create(name: "Nike Air Force 1 Low White '07'", size: 44, price: 199, condition: 5, box: "OG Box", extras: "lacets", user_id: 2)
  
 #  Sneaker.create(name: "Jordan 3 Retro Georgetown (2021)", size: 42, price: 125, condition: 8, box: "OG Box", extras: "lacets", user_id: 2)
 #  Sneaker.create(name: "Nike Dunk Low Retro White Black (2021)", size: 38, price: 149, condition: 10, box: "OG Box", extras: "lacets", user_id: 2)

	# Sneaker.create(name: "Nike Dunk Low Retro Hyper Cobalt (2021)", size: 44, price: 199, condition: 5, box: "OG Box", extras: "lacets", user_id: 2)
 #  Sneaker.create(name: "adidas Yeezy Boost 350 V2 Black Red (2017/2020)", size: 42, price: 125, condition: 8, box: "OG Box", extras: "lacets", user_id: 2)
  
 #  Sneaker.create(name: "Jordan 1 Mid SE All-Star (2021) (GS)", size: 38, price: 149, condition: 10, box: "OG Box", extras: "lacets", user_id: 2)
	# Sneaker.create(name: "Jordan 1 Mid Paint Drip (GS)", size: 44, price: 199, condition: 5, box: "OG Box", extras: "lacets", user_id: 2)
  
 #  Sneaker.create(name: "Nike Air Max 1 Clot Kiss of Death (2021)", size: 42, price: 125, condition: 8, box: "OG Box", extras: "lacets", user_id: 2)
 #  Sneaker.create(name: "Jordan 9 Retro Change The World (W)", size: 38, price: 149, condition: 10, box: "OG Box", extras: "lacets", user_id: 2)
	
	# Sneaker.create(name: "adidas Yeezy Foam RNNR MXT Moon Gray", size: 44, price: 199, condition: 5, box: "OG Box", extras: "lacets", user_id: 2)
 #  Sneaker.create(name: "Jordan 11 Retro Jubilee 25th Anniversary", size: 42, price: 125, condition: 8, box: "OG Box", extras: "lacets", user_id: 2)
  
 #  Sneaker.create(name: "adidas Forum Low Bad Bunny Pink Easter Egg", size: 38, price: 149, condition: 10, box: "OG Box", extras: "lacets", user_id: 2)
	# Sneaker.create(name: "Nike Dunk Low Orange Pearl (W)", size: 44, price: 199, condition: 5, box: "OG Box", extras: "lacets", user_id: 2)
  
 #  Sneaker.create(name: "Nike Air Max 90 \"Football\"", size: 42, price: 125, condition: 8, box: "OG Box", extras: "lacets", user_id: 2)
 #  Sneaker.create(name: "adidas NMD R1 PK \"Footwear White\"", size: 38, price: 149, condition: 10, box: "OG Box", extras: "lacets", user_id: 2)
	# Sneaker.create(name: "Nike Air Presto \"Racer Blue\"", size: 44, price: 199, condition: 5, box: "OG Box", extras: "lacets", user_id: 2)