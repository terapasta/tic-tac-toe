Rails.application.routes.draw do
  devise_for :admin_users
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, only: [:sign_in, :sign_out, :confirmation, :session]


  resources :bots, only: [:index, :edit, :update] do
    resource :imports, only: [:new, :create]
    resource :exports, only: :show
    resources :threads, only: :index do
      resources :messages, only: :index
    end
    # resource :imports, only: [:new, :create]

    resources :trainings do
      get :autocomplete_answer_body, on: :collection
      scope module: :trainings do
        resources :training_messages, only: [:create, :update, :destroy]
        resources :questions, only: :create
        resources :answers, except: [:index, :update] do
          resources :decision_branches, except: :index do
            post :choice, on: :member
          end
        end
      end
    end
    resource :learning, only: [:update]
    resources :answers, except: [:new, :create]
  end

  scope 'embed/:token' do
    resource :chats, only: [:show, :new, :destroy] do
      scope module: :chats do
        resources :messages, only: [:create]
        post 'choices/:id', to: 'choices#create', as: :choices
      end
    end
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
