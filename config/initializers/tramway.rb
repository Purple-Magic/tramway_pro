# frozen_string_literal: true

Tramway::Export.set_exportable_models Tramway::Event::Participant, project: :conference
Tramway::Admin.set_available_models Word,
  ItWay::Certificate,
  project: :conference
Tramway::Api.set_available_models word: { open: %i[index] },
                                  'tramway/event/event': { open: %i[index] }
