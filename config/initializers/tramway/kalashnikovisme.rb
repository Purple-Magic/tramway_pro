# frozen_string_literal: true

Rails.application.config.after_initialize do
  Tramway.initialize_application model_class: RedMagic

  Tramway.set_available_models(
    [
      Course,
      Tramway::User,
      Courses::Topic,
      Courses::Lesson,
      Courses::Video,
      Courses::Comment,
      Courses::Task,
      Courses::Screencast,
      TimeLog,
      Blogs::Link
    ],
    project: :kalashnikovisme
  )

  Tramway.set_available_models(
    [
      Course,
      Courses::Topic,
      Courses::Lesson,
      Courses::Video,
      Courses::Comment,
      Courses::Task,
      Courses::Screencast
    ],

    role: :slurm,
    project: :kalashnikovisme
  )

  Tramway.set_available_models(
    [
      Course,
      Courses::Topic,
      Courses::Lesson,
      Courses::Video,
      Courses::Comment,
      Courses::Task,
      Courses::Screencast
    ],
    role: :skillbox,
    project: :kalashnikovisme
  )

  Tramway.set_available_models(
    [
      Course,
      Courses::Topic,
      Courses::Lesson,
      Courses::Video,
      Courses::Comment,
      Courses::Task,
      Courses::Screencast
    ],
    role: :hexlet,
    project: :kalashnikovisme
  )

  Tramway.navbar_structure(
    Course,
    TimeLog,
    Tramway::User,
    Blogs::Link,
    project: :kalashnikovisme
  )
end
