Rails.application.routes.draw do

  get 'card/new'
  get 'card/show'
  root 'toppage#index'

  resources :user_menu, only: [:index, :show, :new, :create]

  resources :products, only: [:index, :show, :new, :create]

  resources :users, only: [:index, :show, :new]

  resources :card, only: [:new, :show]
end
