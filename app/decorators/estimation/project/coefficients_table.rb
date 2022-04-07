# frozen_string_literal: true

module Estimation::Project::CoefficientsTable
  # :reek:DuplicateMethodCall { enabled: false }
  def coefficients_table
    table do
      result = summary
      coefficients.sort_by(&:position).each do |coefficient|
        prev_result = result
        result *= coefficient.scale
        concat(content_tag(:tr) do
          concat(content_tag(:td) do
            concat coefficient.title
          end)

          concat(content_tag(:td) do
            concat "#{(coefficient.scale * 100 - 100).round(0)} %"
          end)

          concat(content_tag(:td) do
            concat (result - prev_result).round 2
          end)
        end)
      end
    end
  end
  # :reek:ControlParameter { enabled: true }
end
