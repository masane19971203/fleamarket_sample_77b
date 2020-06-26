Rails.application.routes.draw do

  root 'users#new-login'

  resources :user_menu, only: [:index, :show, :new, :create]

  resources :products, only: [:index, :show, :new, :create]

end
