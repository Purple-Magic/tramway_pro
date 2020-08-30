# frozen_string_literal: true

Tramway::Core.initialize_application model_class: PurpleMagic
Tramway::Admin.set_singleton_models PurpleMagic, project: :purple_magic
Tramway::Admin.set_available_models(
  Tramway::Landing::Block,
  Tramway::Page::Page,
  Tramway::User::User,
  project: :purple_magic
)

Tramway::Admin.navbar_structure Tramway::Page::Page, Tramway::User::User, project: :purple_magic
