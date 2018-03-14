Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  mount Tramway::SportSchool::Engine => "/"
end
