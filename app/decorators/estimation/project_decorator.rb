# frozen_string_literal: true

class Estimation::ProjectDecorator < ApplicationDecorator
  delegate_attributes :title, :state, :id

  decorate_associations :tasks, :coefficients, :expenses

  def self.collections
    [:all]
  end

  def self.list_attributes
    [:project_state]
  end

  def self.show_attributes
    %i[id title description team_table expenses_table coefficients_table summary_table]
  end

  def self.show_associations
    %i[tasks expenses coefficients]
  end

  def additional_buttons
    tasks_url = ::Tramway::Export::Engine.routes.url_helpers.export_path(id, model: object.class, collection: :tasks)
    expenses_url = ::Tramway::Export::Engine.routes.url_helpers.export_path(id, model: object.class,
collection: :expenses)
    new_task_path = Tramway::Admin::Engine.routes.url_helpers.new_record_path(
      model: Estimation::Task,
      'estimation/task' => { estimation_project: id },
      redirect: "/admin/records/#{id}?model=Estimation::Project"
    )

    tasks_button_inner = content_tag(:span) do
      concat(fa_icon('tasks'))
      concat(' ')
      concat(fa_icon('file-excel'))
    end

    expenses_button_inner = content_tag(:span) do
      concat(fa_icon('money-check-alt'))
      concat(' ')
      concat(fa_icon('file-excel'))
    end

    {
      show: [
        { url: tasks_url, inner: -> { tasks_button_inner }, color: :success },
        { url: expenses_url, inner: -> { expenses_button_inner }, color: :success },
        { url: new_task_path, inner: -> { fa_icon :plus }, color: :primary }
      ]
    }
  end

  def description
    raw object.description
  end

  include ::Estimation::Project::TeamTable
  include ::Estimation::Project::ExpensesTable
  include ::Estimation::Project::CoefficientsTable
  include ::Estimation::Project::SummaryTable

  def project_state
    state_machine_view object, :project_state
  end

  # :reek:ControlParameter { enabled: false }
  def project_state_button_color(event)
    case event
    when :send_to_customer
      :primary
    when :finish_estimation, :confirmed_by_customer
      :success
    when :decline
      :warning
    end
  end
  # :reek:ControlParameter { enabled: true }
end
