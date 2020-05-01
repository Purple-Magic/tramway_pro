# frozen_string_literal: true

Tramway::Admin.set_singleton_models Listai::Book, project: :engineervol
Tramway::Admin.set_available_models Listai::Page, Tramway::User::User, project: :engineervol
Tramway::Admin.navbar_structure Listai::Book, Tramway::User::User, project: :engineervol
