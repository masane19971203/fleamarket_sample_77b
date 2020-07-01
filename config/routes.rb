Rails.application.routes.draw do

  devise_for :users
  root 'toppage#index'

  resources :user_menu, only: [:index, :show, :new, :create]

  resources :products, only: [:index, :show, :new, :create, :destroy]

  resources :users, only: [:index, :show, :new, :edit, :update]
  resources :users do
    resources :addresses, only: [:new, :create, :update]
  end

end
