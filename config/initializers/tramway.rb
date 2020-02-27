# frozen_string_literal: true

Tramway::Export.set_exportable_models Tramway::Event::Participant, project: :conference
Tramway::Admin.set_available_models Word,
  ItWay::Certificate,
  project: :conference, role: :admin
Tramway::Api.set_available_models word: { open: %i[index] },
                                  'tramway/event/event': { open: %i[index] }
Tramway::Admin.navbar_structure(
  Tramway::Conference::Unity,
  { events_organization: [ Tramway::Event::Event ] }
)
