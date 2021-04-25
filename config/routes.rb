Rails.application.routes.draw do
	root to: "pages#home"
  	devise_for :users, controllers: { 
  		omniauth_callbacks: 'users/omniauth_callbacks',
  		registrations: 'users/registrations'
  	}
	resources :sneakers
	resources :orders, only: [:show, :create]

end
