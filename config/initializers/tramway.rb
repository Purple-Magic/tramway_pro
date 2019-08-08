Tramway::Export.set_exportable_models Tramway::Event::Participant, project: :conference
Tramway::Admin.set_available_models Word, project: :conference
Tramway::Api.set_available_models word: [ :index ]
