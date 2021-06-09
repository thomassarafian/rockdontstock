Rails.application.routes.draw do
	root to: "pages#home"
	devise_for :users, controllers: { 
		omniauth_callbacks: 'users/omniauth_callbacks',
		registrations: 'users/registrations'
	}
	resources :sneakers

	resources :users, only: [:show, :update], path: 'me' do
    # ressources :items
  	resources :transfers, only: [:index, :create]
  end

	resources :orders, only: [:show, :create] do
	  resources :payments, only: [:new]
	end

	# mount StripeEvent::Engine, at: '/stripe-webhooks'
end
