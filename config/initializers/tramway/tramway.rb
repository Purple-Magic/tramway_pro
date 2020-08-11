# frozen_string_literal: true

Tramway::Admin.set_available_models(
  Tramway::User::User,
  Project,
  Tramway::Page::Page,
  Tramway::Profiles::SocialNetwork,
  Tramway::Landing::Block,
  TramwayDev,
  project: :tramway,
  role: :admin
)

Tramway::Admin.navbar_structure(
  Tramway::User::User,
  TramwayDev,
  Project,
  {
    landing: [
      Tramway::Page::Page,
      Tramway::Profiles::SocialNetwork
    ]
  },
  project: :tramway
)
