# frozen_string_literal: true

Tramway::Admin.navbar_structure(
  Tramway::SportSchool::Institution,
  {
    landing: [
      Tramway::Page::Page,
      Tramway::Profiles::SocialNetwork
    ]
  },
  Tramway::User::User,
  project: :sport_school
)
