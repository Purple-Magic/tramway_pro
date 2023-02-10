# frozen_string_literal: true

Rails.application.config.after_initialize do
  Tramway.set_singleton_models Listai::Book, project: :engineervol
  Tramway.set_available_models [ Listai::Page, Tramway::User ], project: :engineervol
  Tramway.navbar_structure Listai::Book, Tramway::User, project: :engineervol
end
