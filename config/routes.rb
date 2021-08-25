Rails.application.routes.draw do
  root to: "pages#home"
  resources :pages, only: [:index]
  
  resource :contact, only: [:create, :new], controller: 'contact'
	
  devise_for :users, controllers: { 
		omniauth_callbacks: 'users/omniauth_callbacks',
		registrations: 'users/registrations',
    sessions: 'users/sessions'
	}
	
  resources :sneakers, only: [:index, :new, :create, :show, :edit, :update, :destroy]

  resources :sneaker_dbs, only: [:index] do
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
  get 'faq' => 'pages#faq'
  post '/', to: 'pages#newsletter'
  
  namespace :forest do
    post '/actions/validate-announcement' => 'sneakers#validate_announcement'
  end

  mount ForestLiana::Engine => '/forest'	

  # mount StripeEvent::Engine, at: '/stripe-webhooks'
end
