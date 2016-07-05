Rails.application.routes.draw do
  devise_for :admin_users
  #resources :messages
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  resource :chats, only: [:show, :create, :destroy]
  resource :dashboards, only: [:show]
  resources :trainings do
    scope module: :trainings do
      resources :training_messages, only: [:create, :update]
    end
  end

  namespace :trainings do
    resources :answers, only: [:update] do
      member do
        post :replace
      end
    end
  end
  root 'chats#show'
end
