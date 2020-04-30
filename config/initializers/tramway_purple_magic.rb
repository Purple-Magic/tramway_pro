Tramway::Core.initialize_application model_class: PurpleMagic
Tramway::Admin.set_singleton_models PurpleMagic, project: :purple_magic
Tramway::Auth.root_path = '/admin'

Tramway::Admin.navbar_structure(
  PurpleMagic,
  {
    my_dropdown:
    [
      :divider
    ]
  },
  project: :purple_magic
)