require 'nokogiri'

doc = File.open(Rails.root.join('bin', 'podcast', 'description', 'description.html')) do |f|
  Nokogiri::HTML(f, nil, Encoding::UTF_8.to_s)
end

include Podcast::EpisodeConcern

text = recursively_build_description doc.elements
puts text
