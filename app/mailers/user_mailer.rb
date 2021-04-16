class UserMailer < ApplicationMailer

	# def mailchimp_trans_client
	# 	@mailchimp_trans_client ||= MailchimpTransactional::Client.new(ENV['MAILCHIMPTRANS_API_KEY'])
	# end	
	
	# def new_user(user) #envoi d'un mail lors de la creation d'un compte
	# 	@user = user 
	# 	mailchimp_trans_client.messages.send({
	# 		'message' => {
	# 			to: [{
	# 				email: user.email, name: user.first_name #user.email
	# 			}],
	# 			subject: "Salut #{user.first_name} ! Bienvenue chez Rock Don't Stock",
	# 		} 
	# 	})

	# end
	
	# def new_sneaker(sneaker, user) #envoi d'un mail lors de la creation d'une chaussure
	# 	mailchimp_trans_client.messages.send_template(
	# 		'template_name' => 'new-sneaker-added',
	# 		'template_content' => [],
	# 		'message' => {
	# 			to: [{
	# 				email: "elliot@rockdontstock.com", name: "Elliot" #user.email
	# 			}],
	# 			subject: "Ta #{sneaker.name} sera bientôt en ligne !", 
	# 			merge_vars: [
	# 				rcpt: "elliot@rockdontstock.com",
	# 				vars: [
	# 					{name: "USER_FIRST_NAME", content: user.first_name},
	# 					{name: "SNEAKER_NAME", content: sneaker.name}
	# 				]
	# 			]
	# 		})
	# end

end
