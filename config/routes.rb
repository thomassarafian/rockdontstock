Rails.application.routes.draw do
  root to: "pages#home"
  resources :pages, only: [:index]
  
  resource :contact, only: [:create, :new], controller: 'contact'
	
  devise_for :users, controllers: { 
		omniauth_callbacks: 'users/omniauth_callbacks',
		registrations: 'users/registrations'
	}
	
  get '/payment-complete', to: "payments#complete"

  resources :sneakers do 
    resources :build, controller: 'sneakers/build'
    resources :orders, only: [:new, :show, :create]
  end
  resources :sneaker_dbs, only: [:index, :create]

	resource :user, only: [:show, :update], path: 'me' do
    resources :items, only: [:index]
  	resources :transfers, only: [:index, :create]
  end

  resources :guides


  get 'zswexddfe'                    => 'pages#zswexddfe'

  # get 'modal_bootstrap'              => 'pages#modal_bootstrap'
  get 'about'                        => 'pages#about'
  get 'faq'                          => 'pages#faq'
  get 'comment-envoyer-une-paire'    => 'pages#how_to_send_shoes'
  get 'authentication'             => 'pages#authentication'
  get 'cgu'                          => 'pages#cgu'
  get 'cgv'                          => 'pages#cgv'
  get 'politique-de-confidentialite' => 'pages#trust_policy'
  post '/', to: 'pages#newsletter'
  
  namespace :forest do
    # Sneakers
    post '/actions/set-as-day-selection'              => 'sneakers#set_as_day_selection'
    post '/actions/set-as-home-selection'             => 'sneakers#set_as_home_selection'
    post '/actions/validate-announcement'             => 'sneakers#validate_announcement'
    post '/actions/reject-announcement-bad-criteria'  => 'sneakers#reject_announcement_bad_criteria'
    post '/actions/reject-announcement-bad-angles'    => 'sneakers#reject_announcement_bad_angles'
    post '/actions/reject-announcement-fake-sneakers' => 'sneakers#reject_announcement_fake_sneakers'
    post '/actions/validate-announcement-bad-photos'  => 'sneakers#validate_announcement_bad_photos'
    post '/actions/missing-information'               => 'sneakers#missing_information'

    # Orders
    post '/actions/cancel-sale-in-24h'                => 'orders#cancel_sale_in_24h'
    post '/actions/cancel-sale-after-48h'             => 'orders#cancel_sale_after_48h'
    post '/actions/seller-send-package'               => 'orders#seller_send_package'
    post '/actions/package-received-by-rds'           => 'orders#package_received_by_rds'
    post '/actions/sneaker-legit'                     => 'orders#sneaker_legit'

    # Guides
    post '/actions/upload-file'                        => 'guides#upload_file'
  end

  mount ForestLiana::Engine => '/forest'	
  mount StripeEvent::Engine, at: '/stripe-webhooks'

end
