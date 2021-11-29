Benchkiller::Offer.active.each_with_index do |offer, index|
  offer.parse!
  print "#{index} of #{Benchkiller::Offer.active.count}\r"
end
