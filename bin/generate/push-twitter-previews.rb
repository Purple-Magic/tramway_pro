ItWay::Person.find_each do |person|
  File.open(Rails.root.join('tmp', "twitter-preview-person-#{person.id}.png")) do |std_file|
    person.twitter_preview = std_file
  end

  person.save!
end
