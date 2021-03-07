# frozen_string_literal: true

Rails.application.routes.draw do
  constraints Constraints::DomainConstraint.new(Settings[Rails.env][:it_way]) do
    mount Tramway::Conference::Engine => '/', as: :it_way
    mount Tramway::Api::Engine, at: '/api', as: :it_way_api
    scope module: :it_way do
      resources :certificates, only: :show
      resources :podcasts, only: :show
    end
  end

  constraints Constraints::DomainConstraint.new(Settings[Rails.env][:kalashnikovisme]) do
    root to: 'kalashnikovisme/web/welcome#index', as: :kalashnikovisme

    mount Tramway::Admin::Engine, at: '/admin', as: :kalash_admin
    mount Tramway::Auth::Engine, at: '/auth', as: :kalash_auth
    # mount Tramway::Site::Engine => '/'
  end

  constraints Constraints::DomainConstraint.new(Settings[Rails.env][:tramway_dev]) do
    root to: 'tramway_dev/web/welcome#index', as: :tramway_dev

    mount Tramway::Admin::Engine, at: '/admin'
    mount Tramway::Auth::Engine, at: '/auth'
  end

  constraints Constraints::DomainConstraint.new(Settings[Rails.env][:engineervol]) do
    root to: 'engineervol/web/welcome#index', as: :engineervol

    mount Tramway::Admin::Engine, at: '/admin', as: :vol_admin
    mount Tramway::Auth::Engine, at: '/auth', as: :vol_auth
  end

  constraints Constraints::DomainConstraint.new(Settings[Rails.env][:purple_magic]) do
    root to: 'purple_magic/web/welcome#index', as: :purple_magic

    mount Tramway::Admin::Engine, at: '/admin', as: :purple_magic_admin
    mount Tramway::Auth::Engine, at: '/auth', as: :purple_magic_auth
  end

  constraints Constraints::DomainConstraint.new(Settings[Rails.env][:gorodsad73]) do
    root to: 'gorodsad73/web/welcome#index', as: :gorod

    mount Tramway::Admin::Engine, at: '/admin', as: :gorod_admin
    mount Tramway::Page::Engine, at: '/page', as: :gorod_page
  end

  constraints Constraints::DomainConstraint.new(Settings[Rails.env][:red_magic]) do
    root to: 'red_magic/web/welcome#index', as: :red_magic_root

    mount Tramway::Admin::Engine, at: '/admin', as: :red_magic_admin
    mount Tramway::Auth::Engine, at: '/auth', as: :red_magic_auth
    mount Tramway::Page::Engine, at: '/page', as: :red_magic
  end
end
