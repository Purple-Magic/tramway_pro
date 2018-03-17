Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  root to: 'web/distribution#index'

  mount Tramway::SportSchool::Engine => "/sport_school"
end
