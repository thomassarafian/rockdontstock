Rails.application.routes.draw do
  get 'users/show'
	root to: "pages#home"
	devise_for :users, controllers: { 
		omniauth_callbacks: 'users/omniauth_callbacks',
		registrations: 'users/registrations'
	}
	resources :sneakers

	resources :users, only: [:show] do
		resources :transfers, only: :new
	end

	resources :orders, only: [:show, :create] do
	  resources :payments, only: :new
	end
end
