# frozen_string_literal: true

module Estimation::ProjectConcern
  def ending_summary
    result = summary
    coefficients.each do |coeff|
      result *= coeff.scale
    end
    result.round
  end

  def summary_row
    concat(content_tag(:tr) do
      5.times { concat(content_tag(:td)) }

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
end
