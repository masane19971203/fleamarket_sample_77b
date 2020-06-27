Rails.application.routes.draw do

  devise_for :users
  root 'toppage#index'

  resources :user_menu, only: [:index, :show, :new, :create]

  resources :products, only: [:index, :show, :new, :create]

  resources :users, only: [:index, :show, :new]
  resources :users do
    resources :addresses, only: [:new, :create, :update]
  end

end
