Rails.application.routes.draw do
  devise_for :admin_users
  #resources :messages
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users

  resources :bots do
    resource :chats, only: [:show, :new, :destroy] do
      scope module: :chats do
        resources :messages, only: [:create]
      end
    end
  end

  resource :learning, only: [:update]

  resource :dashboards, only: [:show]
  resources :trainings do
    scope module: :trainings do
      resources :training_messages, only: [:create, :update]
      resources :answers, only: [:update] do
        member do
          post :replace
        end
      end
    end
  end

  namespace :api, { format: 'json' } do
    namespace :v1 do
      resources :messages, only: :create
    end
  end

  # root 'chats#show'
  root 'dashboards#show'
end
