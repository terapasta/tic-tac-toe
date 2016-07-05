Rails.application.routes.draw do
  devise_for :admin_users
  #resources :messages
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users

  resource :chats, only: [:show, :new, :destroy] do
    scope module: :chats do
      resources :messages, only: [:create]
    end
  end

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
  root 'chats#show'
end
