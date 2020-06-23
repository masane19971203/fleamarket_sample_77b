Rails.application.routes.draw do

  root 'toppage#index'
  resources :products, only: [:new, :create, :show]
  resources :user_menu, only: [:index, :show, :new, :create]
end
