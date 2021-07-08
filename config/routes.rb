Rails.application.routes.draw do
	root to: "pages#home"
  resources :pages, only: [:index]
  
  resource :contact, only: [:create, :new], controller: 'contact'
	
  devise_for :users, controllers: { 
		omniauth_callbacks: 'users/omniauth_callbacks',
		registrations: 'users/registrations',
    sessions: 'users/sessions',
	}
	
  resources :sneakers, only: [:index, :show, :edit, :update]

  resources :sneaker_dbs, only: [:index, :show] do
    resources :sneakers, only: [:new, :create]
  end

	resource :user, only: [:show, :update], path: 'me' do
    resources :items, only: [:index]
  	resources :transfers, only: [:index, :create]
  end

	resources :orders, only: [:show, :create] do
	  resources :payments, only: [:new]
	end

  get 'about' => 'pages#about'
  
	
  # mount StripeEvent::Engine, at: '/stripe-webhooks'
end
