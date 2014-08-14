Rails.application.routes.draw do
  root "servers#index"
  resources :servers
  resources :revisions
  devise_for :users
end
