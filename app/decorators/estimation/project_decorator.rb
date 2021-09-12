# frozen_string_literal: true

class Estimation::ProjectDecorator < Tramway::Core::ApplicationDecorator
  delegate_attributes :title, :state, :id

  decorate_associations :tasks, :coefficients

  def self.collections
    [:all]
  end

  def self.list_attributes
    [:project_state]
  end

  def self.show_attributes
    %i[id title table description]
  end

  def self.show_associations
    %i[tasks coefficients]
  end

  def additional_buttons
    url = ::Tramway::Export::Engine.routes.url_helpers.export_path(id, model: object.class, collection: :tasks)
    new_task_path = Tramway::Admin::Engine.routes.url_helpers.new_record_path(
      model: Estimation::Task,
      'estimation/task' => { estimation_project: id },
      redirect: "/admin/records/#{id}?model=Estimation::Project"
    )

    {
      show: [
        { url: url, inner: -> { fa_icon 'file-excel' }, color: :success },
        { url: new_task_path, inner: -> { fa_icon :plus }, color: :primary }
      ]
    }
  end

  def table
    content_tag(:table) do
      header
      body
      summary_row
      footer
    end
  end

  def description
    raw object.description
  end

  def summary
    tasks.sum(&:sum)
  end

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

  private

  COLUMNS = %i[title hours price price_with_coefficients specialists_count description sum sum_with_coefficients].freeze

  include Estimation::ProjectConcern

  def header
    concat(content_tag(:thead) do
      COLUMNS.each do |attribute|
        concat(content_tag(:th) do
          concat(content_tag(:span, style: 'font-size: 10pt') do
            Estimation::Task.human_attribute_name(attribute)
          end)
        end)
      end
    end)
  end

  def body
    tasks.each do |task|
      concat(content_tag(:tr) do
        COLUMNS.each do |attribute|
          concat(content_tag(:td) do
            concat task.send(attribute)
          end)
        end
      end)
    end
  end

  # :reek:DuplicateMethodCall { enabled: false }
  def footer
    coefficients.each do |coefficient|
      concat(content_tag(:tr) do
        concat(content_tag(:td) do
          concat coefficient.title
        end)

        concat(content_tag(:td) do
          concat "#{(coefficient.scale * 100 - 100).round(0)} %"
        end)

        4.times { concat(content_tag(:td)) }
      end)
    end
  end
  # :reek:ControlParameter { enabled: true }
end
