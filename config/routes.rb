Rails.application.routes.draw do
  constraints Constraints::DomainConstraint.new(Settings[Rails.env][:sportschool_ulsk]) do
    mount Ckeditor::Engine => '/ckeditor'
    mount Tramway::SportSchool::Engine => "/"
  end

  constraints Constraints::DomainConstraint.new(Settings[Rails.env][:it_way]) do
    root to: 'web/distribution#index'
  end
end
