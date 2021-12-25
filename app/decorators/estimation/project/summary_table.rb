# frozen_string_literal: true

module Estimation::Project::SummaryTable
  SUMMARY_TABLE_COLUMNS = %i[
    team_summary
    real_team_summary
    expenses_summary
    real_expenses_summary
    summary
    real_summary
    summary_with_coefficients
  ].freeze

  def team_summary
    tasks.sum(&:sum)
  end

  def expenses_summary
    expenses.sum(&:sum)
  end

  def summary
    team_summary + expenses_summary
  end

  def summary_with_coefficients
    tasks.sum(&:sum_with_coefficients) + expenses.sum(&:sum_with_coefficients)
  end

  def real_team_summary
    tasks.sum(&:real_sum)
  end

  def real_expenses_summary
    expenses.sum(&:real_sum)
  end

  def real_summary
    real_team_summary + real_expenses_summary
  end

  def summary_table
    content_tag(:table) do
      concat(content_tag(:thead) do
        SUMMARY_TABLE_COLUMNS.each do |column|
          concat(content_tag(:th) do
            Estimation::Project.human_attribute_name(column)
          end)
        end
      end)
      concat(content_tag(:tr) do
        SUMMARY_TABLE_COLUMNS.each do |column|
          concat(content_tag(:td) do
            concat(public_send(column))
          end)
        end
      end)
    end
  end
end
