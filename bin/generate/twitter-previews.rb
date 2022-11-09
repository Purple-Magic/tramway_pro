ItWay::Person.find_each do |person|
  path = "tmp/twitter-preview-person-#{person.id}.png"
  system "cutycapt --url=http://it-way.pro/people/previews/#{person.id} --out=#{path}"
end
