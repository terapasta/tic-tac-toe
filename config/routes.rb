Rails.application.routes.draw do
  get :styleguide, to: 'pages#styleguide'

  devise_for :users, only: [:sign_in, :sign_out, :confirmation, :session, :password]
  as :user do
    get 'users/edit' => 'devise/registrations#edit', as: 'edit_user_registration'
    put 'users' => 'devise/registrations#update', as: 'user_registration'
  end

  resources :bots, only: [:show, :index] do
    namespace :settings do
      get 'embed', to: 'pages#embed'
      resource :bot, only: [:show, :update]
      resource :allowed_hosts, only: [:show, :update]
      resource :allowed_ip_addresses, only: [:show, :update]
      resource :reset, only: [:show, :create]
    end
    member do
      post :reset
    end
    resources :tasks, only: [:index, :update]
    resource :chat_widget, only: [:show]
    resources :sentence_synonyms, only: [:index, :new, :create, :destroy]
    resources :imported_sentence_synonyms, only: [:index, :new, :create, :destroy]
    resources :question_answers do
      resource :selections, only: [:create, :destroy], module: :question_answers
      resource :answer, only: [:show], module: :question_answers
      collection do
        get :autocomplete_answer_body
        resources :selections, only: [:index], module: :question_answers, as: :question_answers_selections
      end
    end
    resource :topic_tags, only: [:show, :update]
    resource :imports, only: [:show, :create]
    resources :exports, only: [:index, :create]
    resources :chat_tests, only: [:new, :create, :show]
    resources :threads, only: :index do
      resources :messages, only: [:index] do
        resource :answer_marked, only: [:create, :destroy], controller: :answer_marked
      end
    end
    # resource :imports, only: [:new, :create]

    resource :learning, only: [:show, :update]
    resources :answers, except: [:new] do
      resources :decision_branches, only: [:index]
      resources :question_answers, only: [:index], module: :answers
    end
    resources :decision_branches, only: [:show, :update, :create, :destroy]
    resource :conversation_tree, only: [:show]
    resources :word_mappings
    resources :allowed_ip_addresses, only: [:index, :new, :create, :edit, :update, :destroy]
  end

  resources :imported_sentence_synonyms, only: [:index, :new, :create, :destroy]

  scope 'embed/:token' do
    resource :chats, only: [:show, :new, :destroy] do
      get :show_old
      get :new_old
      scope module: :chats do
        resources :messages, only: [:index, :create] do
          resource :rating, only: [], controller: :message_rating do
            member do
              put :good
              put :bad
              put :nothing
            end
          end
        end
        resources :trainings, only: [:create]
        post 'choices/:id', to: 'choices#create', as: :choices
      end
    end
  end

  namespace :admin do
    resources :word_mappings
    resources :bots, only: [] do
      resources :accuracy_test_cases, only: [:index, :create, :edit, :update, :destroy], module: :bots do
        collection do
          resource :execution, only: [:create], module: :accuracy_test_cases, as: :accuracy_test_cases_execution
        end
      end
    end
  end

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  namespace :api, { format: 'json' } do
    resources :messages, only: :create
    resources :question_answers
    resources :public_bots, param: :token, only: [:show]
    resources :bots do
      resources :topic_tags, module: :bots
      resources :question_answers, module: :bots do
        resources :topic_taggings, module: :question_answers
        resources :decision_branches, module: :question_answers
        resource :child_decision_branches, only: [:destroy], module: :question_answers
      end
      resources :decision_branches, module: :bots do
        resource :child_decision_branches, only: [:destroy], module: :decision_branches
      end
      resources :answers, module: :bots
    end
  end

  resource :contacts, only: [:new, :create]

  # authenticated :admin_user do
  #   #rails_admin.dashboard_path
  # end
  # authenticated :user do
  #   root 'dashboards#show', as: :user_root
  # end
  root 'bots#index'
end
