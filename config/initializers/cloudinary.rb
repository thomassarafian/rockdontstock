Cloudinary.config do |config|
  config.cloud_name = ENV['CLOUDINARY_NAME']
  config.api_key = ENV['CLOUDINARY_API_KEY']
  config.api_secret = ENV['CLOUDINARY_SECRET_KEY']
  config.secure = true
  config.cdn_subdomain = true
  config.transformation = [
    {:width => 2000, :height => 2000, :crop => :limit, :quality => :auto}
  ]
end