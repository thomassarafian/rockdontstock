require "date" 

module UsersHelper

	def full_name
		@user.first_name.capitalize + " " + @user.last_name.capitalize
	end

	def age(dob)
		p "AGE DOB AGE DOB AGE DOB"
		p "AGE DOB AGE DOB AGE DOB"
		p "AGE DOB AGE DOB AGE DOB"
		p "AGE DOB AGE DOB AGE DOB"
		p "AGE DOB AGE DOB AGE DOB"
		p "AGE DOB AGE DOB AGE DOB"
		
	  now = Time.now.utc.to_date
	  now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
	end



end
