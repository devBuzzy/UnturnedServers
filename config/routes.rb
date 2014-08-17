Rails.application.routes.draw do
  root "servers#index"
  post '/contact', :to => "application#contact"
  resources :servers do
  	resources :comments
    resources :reports
    resources :favorites do 
      post :favor
    end
  	post :cast_vote
  	get :vote
    get :banner
  end
  resources :revisions
  devise_for :users
  get 'ping' => proc {|env| [200, {}, []] }
end
