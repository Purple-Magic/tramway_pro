Tramway::Admin.set_available_models(
  Tramway::User::User,
  Project,
  Tramway::Page::Page,
  Tramway::Profiles::SocialNetwork,
  Tramway::Landing::Block,
  project: :tramway
)

Tramway::Admin.navbar_structure(
  Tramway::User::User,
  Project,
  {
    landing: [
      Tramway::Page::Page,
      Tramway::Profiles::SocialNetwork
    ]
  },
  project: :tramway
)
