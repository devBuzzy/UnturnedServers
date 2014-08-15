Rails.application.routes.draw do
  root "servers#index"
  resources :servers do
  	resources :comments
  	post :cast_vote
  	get :vote
  end
  resources :revisions
  devise_for :users
end
