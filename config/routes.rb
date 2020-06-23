Rails.application.routes.draw do

  root 'toppage#index'
  resources :products, only: [:new, :create]
  resources :user_menu, only: [:index, :show, :new, :create]
end
