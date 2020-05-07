# frozen_string_literal: true

Rails.application.routes.draw do
  constraints Constraints::DomainConstraint.new(Settings[Rails.env][:sportschool_ulsk]) do
    mount Ckeditor::Engine => '/ckeditor'
    mount Tramway::SportSchool::Engine => '/'
  end

  constraints Constraints::DomainConstraint.new(Settings[Rails.env][:it_way]) do
    mount Tramway::Conference::Engine => '/'
    mount Tramway::Api::Engine, at: '/api'
    scope module: :it_way do
      resources :certificates, only: :show
    end
  end

  constraints Constraints::DomainConstraint.new(Settings[Rails.env][:kalashnikovisme]) do
    mount Tramway::Site::Engine => '/'
  end

  constraints Constraints::DomainConstraint.new(Settings[Rails.env][:tramway_dev]) do
    mount Tramway::Admin::Engine, at: '/admin'
    mount Tramway::Auth::Engine, at: '/auth'
  end

  constraints Constraints::DomainConstraint.new(Settings[Rails.env][:engineervol]) do
    root to: 'engineervol/web/welcome#index'
    mount Tramway::Admin::Engine, at: '/admin', as: :vol_admin
    mount Tramway::Auth::Engine, at: '/auth', as: :vol_auth
  end

  constraints Constraints::DomainConstraint.new(Settings[Rails.env][:gorodsad73]) do
    root to: 'gorodsad73/web/welcome#index'

    mount Tramway::Admin::Engine, at: '/admin', as: :gorod_admin
    mount Tramway::Page::Engine, at: '/page', as: :gorod_page
  end
end
