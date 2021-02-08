# frozen_string_literal: true

class Estimation::ProjectDecorator < Tramway::Core::ApplicationDecorator
  delegate_attributes :title, :state

  decorate_associations :tasks, :coefficients

  def self.collections
    [:all]
  end

  def self.list_attributes
    [:project_state]
  end

  def self.show_attributes
    %i[id title table]
  end

  def self.show_associations
    %i[tasks coefficients]
  end

  def table
    content_tag :table do
      header
      body
      summary_row
      footer
    end
  end

  def summary
    tasks.sum(&:sum)
  end

  def project_state
    state_machine_view object, :project_state
  end

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

  private

  def header
    concat(content_tag(:thead) do
      %i[title hours price specialists_count sum sum_with_coefficients].each do |attribute|
        concat(content_tag(:th) do
          concat(Estimation::Task.human_attribute_name(attribute))
        end)
      end
    end)
  end

  def body
    tasks.each do |task|
      concat(content_tag(:tr) do
        %i[title hours price specialists_count sum sum_with_coefficients].each do |attribute|
          concat(content_tag(:td) do
            concat task.send(attribute)
          end)
        end
      end)
    end
  end

  def ending_summary
    result = summary
    coefficients.each do |coeff|
      result *= coeff.scale
    end
    result
  end

  def summary_row
    concat(content_tag(:tr) do
      3.times do
        concat(content_tag(:td))
      end
      concat(content_tag(:td) do
        concat(content_tag(:b) do
          concat(Estimation::Project.human_attribute_name(:summary))
        end)
      end)
      %i[summary ending_summary].each do |number|
        concat(content_tag(:td) do
          concat(content_tag(:b) do
            concat(send(number))
          end)
        end)
      end
    end)
  end

  def footer
    coefficients.each do |coefficient|
      concat(content_tag(:tr) do
        concat(content_tag(:td) do
          concat coefficient.title
        end)
        concat(content_tag(:td) do
          concat "#{(coefficient.scale * 100 - 100).round(0)} %"
        end)
        4.times do
          concat(content_tag(:td))
        end
      end)
    end
  end
end
