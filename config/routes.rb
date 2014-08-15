Rails.application.routes.draw do
  root "servers#index"
  resources :servers do
  	resources :comments
  end
  resources :revisions
  devise_for :users
end
