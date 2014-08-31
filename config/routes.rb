Rails.application.routes.draw do
  root "articles#index"
  ActiveAdmin.routes(self)
  post '/contact', :to => "application#contact"
  get '/tag/:tag', :to => "servers#index", :as => "tag"
  get '/version/:version', :to => "servers#index", :as => "version"
  get '/country/:country', :to => "servers#index", :as => "country"
  get '/api', :to => "resources#api", :as => "api"
  get '/terms', :to => "resources#terms", :as => "terms"
  get '/stats', :to => "application#stats", :as => "stats"
  get '/user/:username', :to => "application#user", :as => "user"
  get '/favorites', :to => "application#favorites", :as => "favorites"
  post '/search(/:search)', :to => "servers#search", :as => "search"
  get '/countries', :to => "application#countries", :as => "countries"
  get '/tags', :to => "application#tags", :as => "tags"
  get '/versions', :to => "application#versions", :as => "versions"
  get '/sponsored', :to => "application#sponsored", :as => "sponsored"
  devise_for :users, :controllers => { :registrations => "registrations" }
  resources :servers do
    resources :comments
    resources :reports
    resources :favorites do
      post :favor
    end
    post :cast_vote
    get :vote
    get :banner
    get :embed
    get :display
  end
  resources :revisions
  resources :articles
  get 'ping' => proc {|env| [200, {}, []] }
end
