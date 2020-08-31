# frozen_string_literal: true

Tramway::Admin.set_available_models(
  Tramway::Landing::Block,
  Tramway::Page::Page,
  Tramway::User::User,
  project: :gorodsad73
)

Tramway::Admin.navbar_structure(
  {
    landing: [
      Tramway::Page::Page,
      Tramway::Landing::Block
    ]
  },
  Tramway::User::User,
  project: :gorodsad73
)
