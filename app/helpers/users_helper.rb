require "date" 

module UsersHelper

	def full_name
		@user.first_name + " " + @user.last_name
	end

	def age(dob)
		p "I AM PASSING HERE "
		p "I AM PASSING HERE "
		p "I AM PASSING HERE "
		p "I AM PASSING HERE "
		p "I AM PASSING HERE "
		p "I AM PASSING HERE "
		
	  now = Time.now.utc.to_date
	  now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
	end



end
