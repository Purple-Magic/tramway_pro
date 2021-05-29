# frozen_string_literal: true

Tramway::Core.initialize_application model_class: RedMagic

Tramway::Admin.set_singleton_models RedMagic, project: :red_magic

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
  Podcast,
  Podcast::Episode,
  Video,
  project: :red_magic
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
  {
    podcasts: [
      Podcast
    ]
  },
  {
    videos: [
      Video
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
      {
        index: lambda do |records, _current_user|
          project = Project.where(url: ENV['PROJECT_URL']).first
          records.where(project_id: project.id).where.not(file_url: nil).order(number: :desc)
        end
      },
      {
        show: lambda do |record, _current_user|
          project = Project.where(url: ENV['PROJECT_URL']).first
          record.project_id == project.id
        end
      }
    ],
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
          records.active.where(project_id: project.id)
        end
      },
    ]
  },
  project: :red_magic
)

Tramway::Export.set_exportable_models(
  {
    Estimation::Project => [:tasks]
  },
  {
    Podcast::Episode => [:highlights]
  },
  project: :red_magic
)
