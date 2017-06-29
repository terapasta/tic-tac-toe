Rails.application.routes.draw do
  devise_for :users, only: [:sign_in, :sign_out, :confirmation, :session, :password]
  as :user do
    get 'users/edit' => 'devise/registrations#edit', as: 'edit_user_registration'
    put 'users' => 'devise/registrations#update', as: 'user_registration'
  end

  resources :bots, only: [:index, :edit, :update] do
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
    resources :topic_tags
    resource :imports, only: [:new, :create]
    resources :exports, only: [:index, :show], param: :encoding
    resources :threads, only: :index do
      resources :messages, only: [:index] do
        resource :answer_marked, only: [:create, :destroy], controller: :answer_marked
      end
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
    resource :learning, only: [:show, :update]
    resources :answers, except: [:new] do
      resources :decision_branches, only: [:index]
      resources :training_messages, only: [:index], module: :answers
      resources :question_answers, only: [:index], module: :answers
    end
    resources :decision_branches, only: [:show, :update, :create, :destroy]
    resource :conversation_tree, only: [:show]
    resources :word_mappings
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
        post :executions, to: 'executions#create', on: :collection
      end
    end
  end

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  namespace :api, { format: 'json' } do
    resources :messages, only: :create
    resources :question_answers
    resources :bots do
      resources :topic_tags, module: :bots
      resources :question_answers, module: :bots do
        resources :topic_taggings, module: :question_answers
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
