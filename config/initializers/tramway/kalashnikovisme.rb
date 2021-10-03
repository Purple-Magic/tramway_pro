# frozen_string_literal: true

Tramway::Core.initialize_application model_class: RedMagic

Tramway::Admin.set_available_models Course,
  Tramway::User::User,
  Courses::Topic,
  Courses::Lesson,
  Courses::Video,
  Courses::Comment,
  Courses::Task,
  TimeLog,
  project: :kalashnikovisme

Tramway::Admin.set_available_models Course,
  Courses::Topic,
  Courses::Lesson,
  Courses::Video,
  Courses::Comment,
  Courses::Task,
  role: :slurm,
  project: :kalashnikovisme

Tramway::Admin.set_available_models Course,
  Courses::Topic,
  Courses::Lesson,
  Courses::Video,
  Courses::Comment,
  Courses::Task,
  role: :skillbox,
  project: :kalashnikovisme

Tramway::Admin.navbar_structure(
  Course,
  TimeLog,
  Tramway::User::User,
  project: :kalashnikovisme
)
