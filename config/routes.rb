Rails.application.routes.draw do
  get "reports/new"
  get "reports/show"
  get "reports/index"
  root "servers#index"
  resources :servers do
  	resources :comments
    resources :reports
  	post :cast_vote
  	get :vote
  end
  resources :revisions
  devise_for :users
end
