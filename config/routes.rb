Rails.application.routes.draw do
  constraints DomainConstraint.new('sportschool-ulsk.ru') do
    mount Ckeditor::Engine => '/ckeditor'
    mount Tramway::SportSchool::Engine => "/sport_school"
  end

  root to: 'web/distribution#index'
end
