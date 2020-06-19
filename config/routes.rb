Rails.application.routes.draw do
  root 'user_menu#index'

  resources :user_menu, only: [:show]
end
