# frozen_string_literal: true

Rails.application.config.after_initialize do
  Tramway::Export.set_exportable_models Tramway::Event::Participant, project: :conference
  Tramway.set_available_models Word,
    ItWay::Certificate,
    Podcast,
    Podcast::Episode,
    Tramway::Landing::Block,
    ItWay::Content,
    ItWay::Participation,
    ItWay::Person,
    ItWay::People::Point,
    project: :conference,
    role: :admin

  Tramway.navbar_structure(
    # Tramway::Conference::Unity,
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
    ItWay::Person,
    ItWay::Content,
    {
      other_functions: [
        Word,
        ItWay::Certificate
      ]
    },
    Tramway::User,
    project: :conference
  )

  Tramway::Landing.set_navbar true, project: :conference
end
