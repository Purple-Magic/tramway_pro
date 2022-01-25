# frozen_string_literal: true

Tramway::Core.initialize_application model_class: RedMagic

Tramway::Admin.set_singleton_models RedMagic, project: :red_magic

Tramway::Admin.forms = 'podcast/episodes/add_star', 'podcast/episode/remove_star'

Tramway::Admin.set_available_models(
  Tramway::Landing::Block,
  Tramway::Landing::Tool,
  Tramway::Page::Page,
  Tramway::User::User,
  Tramway::News::News,
  Estimation::Project,
  Estimation::Task,
  Estimation::Customer,
  Estimation::Coefficient,
  Estimation::Expense,
  Estimation::Cost,
  Podcast,
  Podcast::Episode,
  Podcast::Episodes::Topic,
  Podcast::Episodes::Link,
  Podcast::Episodes::Instance,
  Podcast::Episodes::Star,
  Podcast::Episodes::Part,
  Podcast::Highlight,
  Podcast::Music,
  Podcast::Star,
  Content::Story,
  MagicWood::Actor,
  MagicWood::Actors::Photo,
  MagicWood::Actors::Attending,
  Television::Channel,
  Television::Video,
  Television::ScheduleItem,
  project: :red_magic
)

Tramway::Admin.set_available_models(
  Podcast,
  Podcast::Episode,
  Podcast::Episodes::Topic,
  Podcast::Highlight,
  Podcast::Music,
  Podcast::Star,
  project: :red_magic,
  role: :podcast
)

Tramway::Admin.navbar_structure(
  RedMagic,
  {
    estimations: [
      Estimation::Customer,
      Estimation::Project
    ]
  },
  {
    landing: [
      Tramway::Page::Page,
      Tramway::Landing::Block,
      Tramway::Landing::Tool
    ]
  },
  Podcast,
  {
    content: [
      Content::Story
    ]
  },
  {
    magic_wood: [
      MagicWood::Actor,
      MagicWood::Actors::Photo
    ]
  },
  {
    television: [
      Television::Channel,
      Television::Video,
      Television::ScheduleItem
    ]
  },
  Tramway::User::User,
  Tramway::News::News,
  project: :red_magic
)

Tramway::Api.set_available_models(
  {
    Podcast::Highlight => [:create],
    Podcast => [
      index: lambda do |records, _current_user|
        project = Project.where(url: ENV['PROJECT_URL']).first
        records.where project_id: project.id
      end
    ],
    Podcast::Episode => [
      :create,
      :update,
      {
        index: lambda do |records, _current_user|
          project = Project.where(url: ENV['PROJECT_URL']).first
          records.where(project_id: project.id).order(number: :desc)
        end
      },
      {
        show: lambda do |record, _current_user|
          project = Project.where(url: ENV['PROJECT_URL']).first
          record.project_id == project.id
        end
      }
    ],
    Podcast::Episodes::Topic => [:create],
    Products::Task => [:create, :update, :destroy],
    Tramway::News::News => [
      :create,
      {
        index: lambda do |records, _current_user|
          project = Project.where(url: ENV['PROJECT_URL']).first
          records.where(project_id: project.id).order(published_at: :desc)
        end
      },
      {
        show: lambda do |record, _current_user|
          project = Project.where(url: ENV['PROJECT_URL']).first
          record.project_id == project.id
        end
      }
    ],
    Video => [
      {
        index: lambda do |records, _current_user|
          project = Project.where(url: ENV['PROJECT_URL']).first
          records.where(project_id: project.id)
        end
      }
    ],
    Benchkiller::Offer => [:index]
  },
  project: :red_magic
)

Tramway::Export.set_exportable_models(
  {
    Estimation::Project => %i[tasks expenses]
  },
  project: :red_magic
)
