require "date" 

module UsersHelper

	def full_name
		@user.first_name.capitalize + " " + @user.last_name.capitalize
	end

	def age(dob)		
	  now = Time.now.utc.to_date
	  now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
	end

  def format_phone_number(user_phone)
    a = ""
    user_phone.scan(/../) do |w|
      a << "#{w} "
    end
    return a
  end

end
