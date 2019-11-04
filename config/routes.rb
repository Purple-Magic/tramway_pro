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
end
