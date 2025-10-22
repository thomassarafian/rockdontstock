# Only configure Cloudinary if we're using the cloudinary service
if Rails.application.config.active_storage.service == :cloudinary
  Cloudinary.config do |config|
    config.cloud_name = ENV['CLOUDINARY_NAME']
    config.api_key = ENV['CLOUDINARY_API_KEY']
    config.api_secret = ENV['CLOUDINARY_SECRET_KEY']
    config.secure = true
    config.cdn_subdomain = true
  end
end