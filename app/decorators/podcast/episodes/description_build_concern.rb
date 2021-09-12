# frozen_string_literal: true

module Podcast::Episodes::DescriptionBuildConcern
  # :reek:FeatureEnvy { enabled: false }
  def recursively_build_description(elements)
    elements.map do |element|
      case element.name
      when 'text', 'h1'
        element.text
      when 'a'
        "#{element.text} #{element[:href]}"
      when 'li'
        "  * #{recursively_build_description(element.children)}"
      else
        recursively_build_description element.children
      end
    end.join("\n")
  end
  # :reek:FeatureEnvy { enabled: true }

  def raw_description
    recursively_build_description Nokogiri::HTML(description).elements
  end
end
