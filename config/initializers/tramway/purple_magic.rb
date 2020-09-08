# frozen_string_literal: true

Tramway::Core.initialize_application model_class: PurpleMagic
Tramway::Admin.set_singleton_models PurpleMagic, project: :purple_magic
Tramway::Admin.set_available_models(
  Tramway::Landing::Block,
  Tramway::Page::Page,
  Tramway::User::User,
  ChatQuestUlsk::Message,
  project: :purple_magic
)

Tramway::Admin.navbar_structure(
  {
    landing: [
      Tramway::Page::Page,
      Tramway::Landing::Block
    ]
  },
  {
    chat_quest_ulsk: [
      ChatQuestUlsk::Message,
    ],
  },
  Tramway::User::User,
  project: :purple_magic
)
