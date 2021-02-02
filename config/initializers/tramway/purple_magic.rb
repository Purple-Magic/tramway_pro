# frozen_string_literal: true

Tramway::Core.initialize_application model_class: PurpleMagic

Tramway::Admin.set_singleton_models PurpleMagic, project: :purple_magic

Tramway::Admin.set_available_models(
  Tramway::Landing::Block,
  Tramway::Page::Page,
  Tramway::User::User,
  BotTelegram::User,
  BotTelegram::Message,
  BotTelegram::Scenario::Step,
  BotTelegram::Scenario::ProgressRecord,
  Bot,
  Audited::Audit,
  Estimation::Project,
  Estimation::Task,
  Estimation::Customer,
  Estimation::Coefficient,
  project: :purple_magic
)

Tramway::Admin.set_available_models(
  BotTelegram::User,
  BotTelegram::Scenario::Step,
  BotTelegram::Scenario::ProgressRecord,
  role: :partner,
  project: :purple_magic
)

Tramway::Admin.set_available_models(
  Bot,
  BotTelegram::User,
  BotTelegram::Scenario::Step,
  BotTelegram::Scenario::ProgressRecord,
  role: :rsm,
  project: :purple_magic
)

Tramway::Admin.set_available_models(
  Bot,
  BotTelegram::User,
  BotTelegram::Scenario::Step,
  BotTelegram::Scenario::ProgressRecord,
  role: :night,
  project: :purple_magic
)

Tramway::Admin.navbar_structure(
  PurpleMagic,
  {
    landing: [
      Tramway::Page::Page,
      Tramway::Landing::Block
    ]
  },
  {
    bots: [
      Bot,
      BotTelegram::User,
      BotTelegram::Scenario::Step,
      BotTelegram::Scenario::ProgressRecord,
      BotTelegram::Message
    ]
  },
  {
    rsm_project_office_bot: [
    ]
  },
  Audited::Audit,
  Tramway::User::User,
  project: :purple_magic
)

Tramway::Landing.set_navbar false, project: :purple_magic
