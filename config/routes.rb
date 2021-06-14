Rails.application.routes.draw do
  # get 'items/index'
	root to: "pages#home"
  resources :pages, only: [:index, :new, :create]
  get "/contact", to: "pages#contact"


	
  devise_for :users, controllers: { 
		omniauth_callbacks: 'users/omniauth_callbacks',
		registrations: 'users/registrations',
    sessions: 'users/sessions',
	}
	resources :sneakers

	resources :users, only: [:show, :update], path: 'me' do
    resources :items, only: [:index]
  	resources :transfers, only: [:index, :create]
  end

	resources :orders, only: [:show, :create] do
	  resources :payments, only: [:new]
	end

	# mount StripeEvent::Engine, at: '/stripe-webhooks'
end
