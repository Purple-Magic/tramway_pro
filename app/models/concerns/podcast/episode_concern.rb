module Podcast::EpisodeConcern
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
end
