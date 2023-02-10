# frozen_string_literal: true

Rails.application.config.after_initialize do
  Tramway.set_available_models(
    [
      Tramway::User,
      Project,
      Tramway::Page::Page,
      Tramway::Profiles::SocialNetwork,
      Tramway::Landing::Block,
      TramwayDev
    ],
    project: :tramway_dev,
    role: :admin
  )

  Tramway.navbar_structure(
    Tramway::User,
    TramwayDev,
    Project,
    {
      landing: [
        Tramway::Page::Page,
        Tramway::Profiles::SocialNetwork
      ]
    },
    project: :tramway_dev
  )
end
