Rails.application.routes.draw do
  root 'bots#index'

  devise_for :users, only: [:sign_in, :sign_out, :confirmation, :session, :password]

  authenticate :user do
    as :user do
      get 'users/edit' => 'devise/registrations#edit', as: 'edit_user_registration'
      put 'users' => 'devise/registrations#update', as: 'user_registration'
    end

    scope :my do
      get '/' => redirect('/my/password/edit')
      get 'password/edit' => 'my/passwords#edit', as: 'edit_my_password'
      patch 'password' => 'my/passwords#update', as: 'my_password'
      get 'email/edit' => 'my/emails#edit', as: 'edit_my_email'
      patch 'email' => 'my/emails#update', as: 'my_email'
      get 'notification/edit' => 'my/notifications#edit', as: 'edit_my_notification'
      patch 'notification' => 'my/notifications#update', as: 'my_notification'
    end

    resource :contacts, only: [:new, :create]

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
      resources :sentence_synonyms, only: [:index, :new, :create, :destroy]
      resources :imported_sentence_synonyms, only: [:index, :new, :create, :destroy]
      resources :question_answers do
        resource :selections, only: [:create, :destroy], module: :question_answers
        resource :answer, only: [:show], module: :question_answers
        collection do
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

    namespace :api, { format: 'json' } do
      resources :messages, only: :create
      resources :question_answers
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
        resources :messages, module: :bots, only: [] do
          resource :mark, module: :messages, only: [:create, :destroy]
        end

        resources :word_mappings, only: [:create, :update, :destroy], module: :bots
      end
      resources :word_mappings, only: [:create, :update, :destroy]
    end
  end

  scope 'embed/:token' do
    resource :chats, only: [:show, :new, :destroy] do
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

  authenticated :user, ->(u) { u.staff? } do
    namespace :admin do
      resources :word_mappings
      resources :bots, only: [] do
        resources :accuracy_test_cases, only: [:index, :create, :edit, :update, :destroy], module: :bots do
          collection do
            resource :execution, only: [:create], module: :accuracy_test_cases, as: :accuracy_test_cases_execution
          end
        end
      end
      resources :organizations
      resources :tutorials
    end

    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  end

  namespace :api, { format: 'json' } do
    resources :public_bots, param: :token, only: [:show]
    resources :guest_users, only: [:show, :create, :update, :destroy], param: :guest_key
  end
end
