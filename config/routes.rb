Rails.application.routes.draw do

  root 'toppage#index'
  resources :products, only: [:new, :create, :show]
end
