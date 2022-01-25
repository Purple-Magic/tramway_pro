# frozen_string_literal: true

class CourseDecorator < ApplicationDecorator
  decorate_associations :topics

  delegate_attributes :id, :title, :state, :created_at, :updated_at

  class << self
    def collections
      [:all]
    end

    def list_attributes
      []
    end

    def show_attributes
      %i[data time_logs tree]
    end

    def show_associations
      [:topics]
    end

    def list_filters; end
  end

  include Courses::DecoratorHelpers
  include Concerns::TimeLogsTable

  def tree
    content_tag :div do
      concat stylesheet_link_tag '/assets/kalashnikovisme/courses'
      concat(content_tag(:ul, class: :tree) do
        topics.each do |topic|
          topic_row topic
        end
      end)
    end
  end

  def data
    content_tag :table do
      data_table_header
      data_table_body
    end
  end
end
