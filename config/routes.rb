Rails.application.routes.draw do
  devise_for :admin_users
  #resources :messages
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  resource :chats, only: [:show, :create, :destroy]
  resource :dashboards, only: [:show]
  resource :trainings
  namespace :trainings do
    post :complete
    resources :answers, only: [:update] do
      member do
        post :replace
        patch :replace_exists 
      end
    end
  end
  root 'chats#show'
end
