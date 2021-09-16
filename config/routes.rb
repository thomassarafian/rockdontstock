Rails.application.routes.draw do
  root to: "pages#home"
  resources :pages, only: [:index]
  
  resource :contact, only: [:create, :new], controller: 'contact'
	
  devise_for :users, controllers: { 
		omniauth_callbacks: 'users/omniauth_callbacks',
		registrations: 'users/registrations',
    sessions: 'users/sessions'
	}
	
  resources :sneakers, only: [:index, :new, :create, :edit, :update, :show, :destroy]

  resources :sneaker_dbs, only: [:index, :create] do
    resources :sneakers, only: [:new, :create]
  end


	resource :user, only: [:show, :update], path: 'me' do
    resources :items, only: [:index]
  	resources :transfers, only: [:index, :create]
  end


	# resources :orders, only: [:show, :create] do
	  # resources :payments, only: [:new]
	# end

  get 'about' => 'pages#about'
  get 'faq' => 'pages#faq'
  get 'comment-envoyer-une-paire' => 'pages#how_to_send_shoes'
  get 'authentification' => 'pages#authentification'
  get 'cgu' => 'pages#cgu'
  get 'cgv' => 'pages#cgv'
  get 'politique-de-confidentialite' => 'pages#trust_policy'
  post '/', to: 'pages#newsletter'
  
  namespace :forest do
    post '/actions/validate-announcement' => 'sneakers#validate_announcement'
    post '/actions/reject-announcement-bad-criteria' => 'sneakers#reject_announcement_bad_criteria'
    post '/actions/reject-announcement-bad-angles' => 'sneakers#reject_announcement_bad_angles'
    post '/actions/reject-announcement-fake-sneakers' => 'sneakers#reject_announcement_fake_sneakers'
  end

  mount ForestLiana::Engine => '/forest'	

  # mount StripeEvent::Engine, at: '/stripe-webhooks'




end
