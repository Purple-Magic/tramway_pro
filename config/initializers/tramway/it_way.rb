# frozen_string_literal: true

Tramway::Export.set_exportable_models Tramway::Event::Participant, project: :conference
Tramway::Admin.set_available_models Word,
  ItWay::Certificate,
  Podcast,
  project: :conference, role: :admin
# Tramway::Api.set_available_models(
#  { Word => [ :index ] },
#  project: :it_way
# )
Tramway::Admin.navbar_structure(
  Tramway::Conference::Unity,
  {
    events_organization: [
      Tramway::Event::Event,
      Tramway::Event::Participant,
      Tramway::Event::ParticipantFormField,
      Tramway::Event::Place,
      :divider,
      Tramway::Event::Section,
      Tramway::Event::Person,
      Tramway::Event::Partaking,
      :divider,
      Tramway::Partner::Organization,
      Tramway::Partner::Partnership
    ]
  },
  {
    landing: [
      Tramway::Page::Page,
      Tramway::Landing::Block,
      Tramway::Profiles::SocialNetwork
    ]
  },
  Podcast,
  {
    other_functions: [
      Word,
      ItWay::Certificate
    ]
  },
  Tramway::User::User,
  project: :conference
)
