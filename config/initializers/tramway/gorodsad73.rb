# frozen_string_literal: true

Tramway::Admin.set_available_models(
  Tramway::Landing::Block,
  Tramway::Page::Page,
  Tramway::User::User,
  project: :gorodsad73
)

Tramway::Admin.navbar_structure Tramway::Page::Page, Tramway::User::User, project: :gorodsad73
