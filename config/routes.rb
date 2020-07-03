Rails.application.routes.draw do

  get 'card/new'
  get 'card/show'
  devise_for :users
  root 'toppage#index'

  resources :user_menu, only: [:index, :show, :new, :create]

  resources :products, only: [:index,:new, :create, :show]

  resources :users, only: [:index, :show, :new, :edit, :update] do
    resources :addresses, only: [:new, :create, :update]
  end

  resources :card, only: [:new, :index] do
    collection do
      resources :card, only: [:create, :destroy]
    end
  end
  resources :users do 
    get "/products", to: "products#user_index"
  end

  resources :exhibition, only: [:index] 
end
