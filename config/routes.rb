Rails.application.routes.draw do
  root "servers#index"
  post '/contact', :to => "application#contact"
  get '/tag/:tag', :to => "servers#index", :as => "tag"
  get '/version/:version', :to => "servers#index", :as => "version"
  post '/search', :to => "servers#index", :as => "search"
  get '/api', :to => "resources#api", :as => "api"
  get '/stats', :to => "application#stats", :as => "stats"
  get '/user/:username', :to => "application#user", :as => "user"
  devise_for :users, :controllers => { :registrations => "registrations" }
  resources :servers do
    post :index
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
  get 'ping' => proc {|env| [200, {}, []] }
end
