Rails.application.routes.draw do
  devise_for :admin_users
  #resources :messages
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, only: [:sign_in, :sign_out, :confirmation, :session]

  resources :bots, only: [:index, :edit, :update] do
    resource :chats, only: [:show, :new, :destroy] do
      scope module: :chats do
        resources :messages, only: [:create]
        resources :choices, only: [:create]
      end
    end

    resources :trainings do
      get :autocomplete_answer_body, on: :collection
      scope module: :trainings do
        resources :training_messages, only: [:create, :update]
        resources :answers, only: [:update] do
          member do
            post :replace
          end
          resources :decision_branches, except: :index
        end
      end
    end
    resource :learning, only: [:update]

    resource :helpdesks, only: [:new, :create]
  end


  resource :dashboards, only: [:show]

  namespace :api, { format: 'json' } do
    namespace :v1 do
      resources :messages, only: :create
    end
  end

  # authenticated :admin_user do
  #   #rails_admin.dashboard_path
  # end
  # authenticated :user do
  #   root 'dashboards#show', as: :user_root
  # end
  root 'bots#index'
end
