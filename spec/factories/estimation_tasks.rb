# frozen_string_literal: true

FactoryBot.define do
  factory :estimation_task, class: 'Estimation::Task' do
    title
    estimation_project
    hours { generate :float }
    price { generate :float }
    specialists_count { generate :integer }
  end

  factory :estimation_task_admin_attributes, class: 'Estimation::Task' do
    title
    estimation_project { (Estimation::Project.last || create(:estimation_project)).title }
    hours { generate :float }
    price { generate :float }
    specialists_count { generate :integer }
  end
end
