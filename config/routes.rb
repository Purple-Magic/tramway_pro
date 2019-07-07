Rails.application.routes.draw do
  constraints Constraints::DomainConstraint.new(Settings[Rails.env][:sportschool_ulsk]) do
    mount Ckeditor::Engine => '/ckeditor'
    mount Tramway::SportSchool::Engine => '/'
  end

  constraints Constraints::DomainConstraint.new(Settings[Rails.env][:it_way]) do
    mount Tramway::Conference::Engine => '/'
  end

  constraints Constraints::DomainConstraint.new(Settings[Rails.env][:kalashnikovisme]) do
    mount Tramway::Site::Engine => '/'
  end
end
