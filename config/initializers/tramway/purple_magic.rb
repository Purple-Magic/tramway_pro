# frozen_string_literal: true

Rails.application.config.after_initialize do
  Tramway.initialize_application model_class: PurpleMagic

  Tramway.set_singleton_models PurpleMagic, project: :purple_magic

  Tramway.set_available_models(
    [
      Tramway::Landing::Block,
      Tramway::Page::Page,
      Tramway::User,
      BotTelegram::User,
      BotTelegram::Message,
      BotTelegram::Scenario::Step,
      BotTelegram::Scenario::ProgressRecord,
      Bot,
      Estimation::Project,
      Estimation::Task,
      Estimation::Customer,
      Estimation::Coefficient,
      Estimation::Expense,
      Estimation::Cost,
      Benchkiller::User,
      Benchkiller::Company,
      Benchkiller::Notification,
      Benchkiller::Offer,
      Benchkiller::Tag,
      Benchkiller::Collation,
      FindMeds::Feedback,
      Product,
      Products::Task,
      TimeLog
    ],
    project: :purple_magic
  )

  Tramway.set_available_models(
    [
      BotTelegram::User,
      BotTelegram::Scenario::Step,
      BotTelegram::Scenario::ProgressRecord
    ],
    role: :partner,
    project: :purple_magic
  )

  Tramway.set_available_models(
    [
      Bot,
      BotTelegram::User,
      BotTelegram::Scenario::Step,
      BotTelegram::Scenario::ProgressRecord,
      BotTelegram::Message
    ],
    role: :night,
    project: :purple_magic
  )

  Tramway.set_available_models(
    [
      Bot,
      Benchkiller::User,
      Benchkiller::Company,
      Benchkiller::Notification,
      Benchkiller::Offer,
      Benchkiller::Tag,
      Benchkiller::Collation
    ],
    role: :benchkiller,
    project: :purple_magic
  )

  Tramway.navbar_structure(
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
      benchkiller: [
        Benchkiller::User,
        Benchkiller::Company,
        Benchkiller::Notification,
        Benchkiller::Offer,
        Benchkiller::Tag,
        Benchkiller::Collation
      ]
    },
    {
      estimations: [
        Estimation::Customer,
        Estimation::Project
      ]
    },
    {
      find_meds: [
        FindMeds::Feedback
      ]
    },
    {
      product_engine: [
        Product,
        TimeLog
      ]
    },
    Tramway::User,
    project: :purple_magic
  )

  Tramway::Export.set_exportable_models(
    {
      Estimation::Project => %i[single_tasks expenses]
    },
    {
      Product => [:tasks]
    },
    TimeLog,
    project: :purple_magic
  )

  Tramway::Landing.set_navbar false, project: :purple_magic
end
