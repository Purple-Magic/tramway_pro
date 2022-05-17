# frozen_string_literal: true

class Estimation::ProjectDecorator < ApplicationDecorator
  delegate_attributes :title, :state, :id

  decorate_associations :tasks, :coefficients, :expenses
  decorate_association :associated

  class << self
    def collections
      %i[all confirmed declined]
    end

    def list_attributes
      [:project_state]
    end

    def show_attributes
      %i[associated_link pre_estimated_time team_table expenses_table coefficients_table summary_table]
    end

    def show_associations
      %i[tasks expenses coefficients]
    end
  end

  def additional_buttons
    tasks_url = ::Tramway::Export::Engine.routes.url_helpers.export_path(id, model: object.class,
collection: :single_tasks)
    expenses_url = ::Tramway::Export::Engine.routes.url_helpers.export_path(id, model: object.class,
collection: :expenses)
    new_task_path = Tramway::Admin::Engine.routes.url_helpers.new_record_path(
      model: Estimation::Task,
      'estimation/task' => { estimation_project: id },
      redirect: "/admin/records/#{id}?model=Estimation::Project"
    )
    current_host = ENV['PROJECT_URL'].split('.').first.gsub('-', '_')
    calc_by_associated_path = Rails.application.routes.url_helpers.public_send "#{current_host}_api_v1_estimation_project_path",
      id: id, process: :calc

    buttons = [
      { url: tasks_url, inner: -> { tasks_button_inner }, color: :success },
      { url: expenses_url, inner: -> { expenses_button_inner }, color: :success },
      { url: new_task_path, inner: -> { fa_icon :plus }, color: :primary }
    ]

    if object.associated.present?
      buttons << { url: calc_by_associated_path, method: :patch, inner: lambda {
                                                                          fa_icon :calculator
                                                                        }, color: :primary }
    end

    { show: buttons }
  end

  def associated_link
    if object.associated.present?
      link_to associated.title,
        ::Tramway::Admin::Engine.routes.url_helpers.record_path(object.associated_id, model: object.associated_type)
    end
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

  def pre_estimated_time
    if associated.present?
      courses_video_actions = YAML.load_file(Rails.root.join('lib', 'yaml', 'time_logs_actions.yml'))['Courses::Video']
      averages = courses_video_actions.reduce({}) do |hash, action|
        logged_times = Courses::Video.where.not(result_duration: nil).map do |video|
          time_logs = video.time_logs.where(comment: action)
          time_logs.sum(&:minutes) / video.result_duration.to_f if time_logs.any? && video.result_duration.present?
        end.compact
        hash.merge! action => logged_times.median
      end
      table do
        courses_video_actions.each do |action|
          concat(tr do
            concat(th do
              "#{action} на минуту контента"
            end)
            concat(td do
              "#{averages[action].round(2)}m"
            end)
            concat(td do
              "#{(averages[action] / 60).round(2)}h"
            end)
          end)
        end
      end
    else
      "Эта оценка не ассоциирована с другими сущностями, поэтому здесь нет преоценочных сущностей"
    end
  end

  # :reek:ControlParameter { enabled: false }
  def project_state_button_color(event)
    case event
    when :send_to_customer, :calc
      :primary
    when :finish_estimation, :confirmed_by_customer
      :success
    when :decline
      :warning
    end
  end
  # :reek:ControlParameter { enabled: true }

  private

  def tasks_button_inner
    content_tag(:span) do
      concat(fa_icon('tasks'))
      concat(' ')
      concat(fa_icon('file-excel'))
    end
  end

  def expenses_button_inner
    content_tag(:span) do
      concat(fa_icon('money-check-alt'))
      concat(' ')
      concat(fa_icon('file-excel'))
    end
  end
end
