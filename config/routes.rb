Rails.application.routes.draw do
  devise_for :admin_users
  devise_for :users, only: [:sign_in, :sign_out, :confirmation, :session]
  as :user do
    get 'users/edit' => 'devise/registrations#edit', as: 'edit_user_registration'
    put 'users' => 'devise/registrations#update', as: 'user_registration'
  end

  get 'static_pages/help'

  resources :bots, only: [:index, :edit, :update] do
    post :reset, on: :member
    resources :sentence_synonyms, only: [:index, :new, :create, :destroy]
    resources :imported_sentence_synonyms, only: [:index, :new, :create, :destroy]
    resources :question_answers do
      get :autocomplete_answer_body, on: :collection
    end
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
    resources :answers, except: [:new] do
      resources :decision_branches, only: [:index]
      resources :training_messages, only: [:index], module: :answers
      resources :question_answers, only: [:index], module: :answers
    end
    resources :decision_branches, only: [:show, :update, :create, :destroy]
    resource :conversation_tree, only: [:show]
  end

  resources :imported_sentence_synonyms, only: [:index, :new, :create, :destroy]
  resources :word_mappings

  scope 'embed/:token' do
    resource :chats, only: [:show, :new, :destroy] do
      scope module: :chats do
        resources :messages, only: [:create] do
          resource :rating, only: [], controller: :message_rating do
            member do
              put :good
              put :bad
              put :nothing
            end
          end
        end
        post 'choices/:id', to: 'choices#create', as: :choices
      end
    end
  end

  namespace :admin do
    resources :training_texts, only: [:new, :create]
    resources :bots, only: [:index] do
      resources :training_messages, only: [:edit, :update]
      get 'next', to: 'training_messages#next'
    end
  end
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

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
