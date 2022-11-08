ItWay::Person.find_each do |person|
  path = "tmp/twitter-preview-person-#{person.id}.png"
  system "QT_QPA_PLATFORM=wayland cutycapt --url=http://it-way.pro/people/previews/#{person.id} --out=#{path}"
end
