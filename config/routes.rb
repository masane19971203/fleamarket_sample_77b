Rails.application.routes.draw do

  root 'password#forgot-password'

  resources :user_menu, only: [:index, :show, :new, :create]

  resources :products, only: [:index, :show, :new, :create]

end
