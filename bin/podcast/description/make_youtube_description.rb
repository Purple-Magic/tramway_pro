require 'nokogiri'

doc = File.open(Rails.root.join('bin', 'podcast', 'description', 'description.html')) do |f|
  Nokogiri::HTML(f, nil, Encoding::UTF_8.to_s)
end

def recursively_build(elements)
  elements.map do |element|
    case element.name
    when 'text', 'h1'
      element.text
    when 'a'
      "#{element.text} #{element[:href]}"
    when 'li'
      "  * #{recursively_build(element.children)}"
    else
      recursively_build element.children
    end
  end.join("\n")
end

text = recursively_build doc.elements
puts text
