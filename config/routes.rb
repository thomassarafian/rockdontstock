Rails.application.routes.draw do
  	root to: 'sneakers#home'
	resources :sneakers
end
