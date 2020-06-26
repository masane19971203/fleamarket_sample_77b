Rails.application.routes.draw do

  # root 'toppage#index'
  root 'users#new-signup'

  resources :user_menu, only: [:index, :show, :new, :create]

  resources :products, only: [:index, :show, :new, :create]

end
