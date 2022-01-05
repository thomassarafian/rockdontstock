Rails.application.routes.draw do
  root to: "pages#home"
  
  resource :contact, only: [:create, :new], controller: 'contact'
  resources :sneaker_dbs, only: [:index, :create]
	
  devise_for :users, controllers: { 
		omniauth_callbacks: 'users/omniauth_callbacks',
		registrations: 'users/registrations'
	}
  
  resources :sneakers do 
    resources :build, controller: 'sneakers/build' do
      collection do
        get 'success'
      end
    end
    resources :orders, shallow: true, only: [:new, :show, :create]
  end
  
	resource :user, only: [:show, :update], path: 'me' do
    resources :items, only: [:index]
  	resources :transfers, only: [:index, :create]
  end
  
  # PAGES
  get 'about', to: 'pages#about'
  get 'faq', to: 'pages#faq'
  get 'comment-envoyer-une-paire', to: 'pages#how_to_send_shoes'
  get 'authentication', to: 'pages#authentication'
  get 'cgu', to: 'pages#cgu'
  get 'cgv', to: 'pages#cgv'
  get 'politique-de-confidentialite', to: 'pages#trust_policy'
  post 'newsletter', to: 'pages#newsletter'
  post 'guide', to: 'pages#guide_request'
  
  # PAYMENTS
  get 'sneaker-payment-complete', to: "payments#sneaker_complete"
  post 'sneaker-stripe-checkout', to: 'payments#sneaker_stripe_checkout'
  get 'lc-payment-complete', to: "payments#lc_complete"
  post 'lc-stripe-checkout', to: 'payments#lc_stripe_checkout'
  post 'stripe-webhooks', to: 'payments#stripe_webhooks'
  
  namespace :forest do
    # Sneakers
    post '/actions/set-as-day-selection', to: 'sneakers#set_as_day_selection'
    post '/actions/set-as-home-selection', to: 'sneakers#set_as_home_selection'
    post '/actions/validate-announcement', to: 'sneakers#validate_announcement'
    post '/actions/reject-announcement-bad-criteria', to: 'sneakers#reject_announcement_bad_criteria'
    post '/actions/reject-announcement-bad-angles', to: 'sneakers#reject_announcement_bad_angles'
    post '/actions/reject-announcement-fake-sneakers' => 'sneakers#reject_announcement_fake_sneakers'
    post '/actions/validate-announcement-bad-photos', to: 'sneakers#validate_announcement_bad_photos'
    post '/actions/missing-information'  , to: 'sneakers#missing_information'

    # Orders
    post '/actions/cancel-sale-in-24h'   , to: 'orders#cancel_sale_in_24h'
    post '/actions/cancel-sale-after-48h', to: 'orders#cancel_sale_after_48h'
    post '/actions/seller-send-package', to: 'orders#seller_send_package'
    post '/actions/package-received-by-rds', to: 'orders#package_received_by_rds'
    post '/actions/sneaker-legit', to: 'orders#sneaker_legit'

    # Guides
    post '/actions/upload-file', to: 'guides#upload_file'
  end

  mount ForestLiana::Engine => '/forest'	

end
