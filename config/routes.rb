Rails.application.routes.draw do
  root "servers#index"
  resources :servers do
  	resources :comments
    resources :reports
    resources :favorites do 
      post :favor
    end
  	post :cast_vote
  	get :vote
  end
  resources :revisions
  devise_for :users
end
