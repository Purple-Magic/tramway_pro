# frozen_string_literal: true

module Estimation::Project::TeamTable
  def team_table
    content_tag(:table) do
      team_table_header
      team_table_body
    end
  end

  private

  TEAM_TABLE_COLUMNS = %i[title hours price price_with_coefficients specialists_count description sum real_sum
                          sum_with_coefficients].freeze

  def team_table_header
    concat(content_tag(:thead) do
      TEAM_TABLE_COLUMNS.each do |attribute|
        concat(content_tag(:th) do
          concat(content_tag(:span, style: 'font-size: 10pt') do
            Estimation::Task.human_attribute_name(attribute)
          end)
        end)
      end
    end)
  end

  def team_table_body
    tasks.each do |task|
      concat(content_tag(:tr) do
        TEAM_TABLE_COLUMNS.each do |attribute|
          concat(content_tag(:td) do
            case attribute
            when :real_sum
              concat(content_tag(:div, style: 'display: flex; flex-direction: row; justify-content: space-between') do
                concat(task.send(attribute))
                concat(link_to(task.cost_path, class: 'btn btn-warning btn-sm') do
                  fa_icon('pencil-alt')
                end)
              end)
            else
              concat task.send(attribute)
            end
          end)
        end
      end)
    end
  end
end
