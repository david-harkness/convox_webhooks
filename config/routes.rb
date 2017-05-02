Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  resources :apps do
    collection do
      get :deploy_process # TODO: needs to be post
    end
  end
  resources :platforms
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
