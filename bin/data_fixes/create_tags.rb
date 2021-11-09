Benchkiller::Offer.active.each_with_index do |offer, index|
  tags = offer.message.text.scan(/\#[0-9a-zA-Zа-яА-Я]+/)
  tags&.each do |tag|
    tag_obj = Benchkiller::Tag.find_or_create_by! title: tag.to_s.gsub('#', '').underscore, project_id: 7
    offer.tags << tag_obj
    offer.save!
  end
  print "#{index} of #{Benchkiller::Offer.active.count}\r"
end
