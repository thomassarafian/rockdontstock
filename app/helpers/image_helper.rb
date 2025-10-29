module ImageHelper
  # Dynamic image helper that works with both local storage and Cloudinary
  def dynamic_image_tag(photo, options = {})
    return image_tag('/assets/oeil-rds.png', options) if photo.nil?
    
    # If photo is a String (URL), use it directly
    if photo.is_a?(String)
      image_tag(photo, options)
    # If photo is an Active Storage attachment
    elsif photo.respond_to?(:key)
      if Rails.application.config.active_storage.service == :cloudinary
        cl_image_tag(photo.key, options)
      else
        image_tag(photo, options)
      end
    else
      image_tag(photo, options)
    end
  end
  
  # Helper for photo galleries with transformations
  def photo_with_transformation(photo, transformation_options = {})
    return image_tag('/assets/oeil-rds.png', class: transformation_options[:class]) if photo.nil?
    
    # If photo is a String (URL), use regular image_tag (transformations only work with Cloudinary uploads)
    if photo.is_a?(String)
      image_tag(photo, class: transformation_options[:class])
    # If photo is an Active Storage attachment
    elsif photo.respond_to?(:key)
      if Rails.application.config.active_storage.service == :cloudinary
        cl_image_tag(photo.key, raw_transformation: transformation_options[:raw_transformation], class: transformation_options[:class])
      else
        image_tag(photo, class: transformation_options[:class])
      end
    else
      image_tag(photo, class: transformation_options[:class])
    end
  end
  
  # Drop-in replacement for cl_image_tag that works everywhere
  # Handles both Active Storage attachments and String URLs
  def smart_image_tag(photo, options = {})
    return image_tag('/assets/oeil-rds.png', options) if photo.nil?
    
    # If photo is a String (URL), use it directly
    if photo.is_a?(String)
      if Rails.application.config.active_storage.service == :cloudinary && photo.start_with?('http')
        # External URL - use regular image_tag (Cloudinary can't process external URLs without uploading first)
        image_tag(photo, options)
      else
        # Local path or URL
        image_tag(photo, options)
      end
    # If photo is an Active Storage attachment
    elsif photo.respond_to?(:key)
      if Rails.application.config.active_storage.service == :cloudinary
        cl_image_tag(photo.key, options)
      else
        image_tag(photo, options)
      end
    else
      # Fallback - try to use as-is
      image_tag(photo, options)
    end
  end
  
  # Helper for sneaker photos with consistent sizing
  def sneaker_photo_tag(sneaker, options = {})
    photo = sneaker.photos.first
    default_options = { 
      class: 'sneaker-photo', 
      raw_transformation: "c_limit,h_700,q_auto,w_700" 
    }
    
    smart_image_tag(photo, default_options.merge(options))
  end
  
  # Helper for user profile photos
  def profile_photo_tag(user, options = {})
    photo = user.photos&.first
    default_options = { 
      class: 'profile-photo',
      raw_transformation: "c_limit,h_200,q_auto,w_200" 
    }
    
    smart_image_tag(photo, default_options.merge(options))
  end
end
