# frozen_string_literal: true

class Courses::ScreencastDecorator < Tramway::Core::ApplicationDecorator
  # Associations you want to show in admin dashboard
  # decorate_associations :messages, :posts

  delegate_attributes(
    :id,
    :project_id,
    :video_id,
    :scenario,
    :created_at,
    :updated_at,
    :begin_time,
    :end_time,
    :comment
  )

  def title
    "#{begin_time}-#{end_time} #{comment}"
  end

  def file
    content_tag(:video, controls: true, width: '400px') do
      content_tag(:source, '', src: object.file.url)
    end
  end

  def scenario
    raw object.scenario.gsub("\n", '<br/>')
  end

  include Webpacker::Helper

  def preview
    content_tag(:div) do
      concat(link_to('#', id: :run_scenario, class: 'btn btn-success') do
        'Run scenario'
      end)
      concat(content_tag(:br))
      concat(content_tag(:span, id: :scenario, style: 'display: none') do
        object.scenario
      end)
      concat(content_tag(:div, id: :terminal) {})
      concat(content_tag(:span, id: :timer) {})
      concat javascript_pack_tag :application
      concat stylesheet_link_tag '/assets/kalashnikovisme/xterm'
    end
  end

  class << self
    def collections
      [:all]
    end

    def list_attributes
      %i[
        id
        project_id
        video_id
        scenario
      ]
    end

    def show_attributes
      %i[file comment]
    end

    def show_associations; end

    def list_filters; end
  end
end
