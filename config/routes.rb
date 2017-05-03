Rails.application.routes.draw do
  get 'jobs/show'

  get 'jobs/index'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  root to: 'platforms#index'
  resources :platforms do
    resources :apps do
      resources :jobs do
        resources :commands do
        end
      end
      member do
        post :deploy_process
        post :reseed
        post :create_convox_application
      end
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
