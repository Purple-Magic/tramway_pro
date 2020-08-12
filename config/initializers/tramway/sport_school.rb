# frozen_string_literal: true

Tramway::Admin.navbar_structure(
  Tramway::SportSchool::Institution,
  {
    data: [
      Tramway::SportSchool::Document,
      Tramway::SportSchool::KindSport,
      Tramway::SportSchool::Organization,
      Tramway::SportSchool::Trainer
    ]
  },
  {
    landing: [
      Tramway::Page::Page,
      Tramway::Profiles::SocialNetwork
    ]
  },
  Tramway::User::User,
  project: :sport_school
)
