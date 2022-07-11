# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  constraints Constraints::DomainConstraint.new(Settings[Rails.env][:it_way]) do
    mount Tramway::Conference::Engine => '/'
    mount Tramway::Api::Engine, at: '/api', as: :it_way_api

    get '/:id' => 'shortener/shortened_urls#show'
    get '/youtube-callback' => 'youtube_callbacks#create'

    scope module: :it_way do
      resources :certificates, only: :show
      resources :podcasts, only: :show
    end
  end

  constraints Constraints::DomainConstraint.new(Settings[Rails.env][:kalashnikovisme]) do
    root to: 'kalashnikovisme/web/welcome#index'

    mount Tramway::Admin::Engine, at: '/admin', as: :kalash_admin
    mount Tramway::Auth::Engine, at: '/auth', as: :kalash_auth
  end

  constraints Constraints::DomainConstraint.new(Settings[Rails.env][:tramway_dev]) do
    root to: 'tramway_dev/web/welcome#index'

    mount Tramway::Admin::Engine, at: '/admin'
    mount Tramway::Auth::Engine, at: '/auth'
  end

  constraints Constraints::DomainConstraint.new(Settings[Rails.env][:engineervol]) do
    root to: 'engineervol/web/welcome#index'

    mount Tramway::Admin::Engine, at: '/admin', as: :vol_admin
    mount Tramway::Auth::Engine, at: '/auth', as: :vol_auth
  end

  constraints Constraints::DomainConstraint.new(Settings[Rails.env][:purple_magic]) do
    root to: 'purple_magic/web/welcome#index'

    mount Tramway::Admin::Engine, at: '/admin', as: :purple_magic_admin
    mount Tramway::Auth::Engine, at: '/auth', as: :purple_magic_auth

    namespace :purple_magic do
      namespace :api do
        namespace :v1 do
          namespace :estimation do
            resources :projects, only: :update
          end
          namespace :leopold do
            resources :messages, only: :create
          end
        end
      end
    end
  end

  constraints Constraints::DomainConstraint.new(Settings[Rails.env][:benchkiller]) do
    root to: 'benchkiller/web/welcome#index'

    namespace :benchkiller do
      namespace :web do
        resources :sessions, only: [:create]
        get 'sign_out', to: 'sessions#destroy'
        resources :offers, only: :index
        resources :companies, only: %i[show edit update]
        resources :deliveries, only: %i[new create show edit update] do
          member do
            get :run_process
          end
        end
      end

      namespace :api do
        resources :user_tokens, only: :create
        resources :offers, only: :index
        resources :regions, only: :index
      end
    end

    mount Tramway::Admin::Engine, at: '/admin', as: :benchkiller_admin
  end

  constraints Constraints::DomainConstraint.new(Settings[Rails.env][:red_magic]) do
    root to: 'red_magic/web/welcome#index'

    mount Tramway::Admin::Engine, at: '/admin', as: :red_magic_admin
    mount Tramway::Auth::Engine, at: '/auth', as: :red_magic_auth
    mount Tramway::Page::Engine, at: '/page', as: :red_magic
    mount Tramway::Api::Engine, at: '/api', as: :red_magic_api

    namespace :red_magic do
      namespace :api do
        namespace :v1 do
          namespace :podcast do
            resources :episodes, only: :update do
              member do
                patch :video_is_ready
              end
            end
          end
          namespace :content do
            resources :stories, only: :update
          end
          namespace :estimation do
            resources :projects, only: :update
          end
        end
      end
    end
  end
end
