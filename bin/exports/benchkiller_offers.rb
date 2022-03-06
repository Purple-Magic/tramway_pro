require 'csv'

CSV.open('offers.csv', 'w') do |csv|
  Benchkiller::Offer.last(10_000).map.with_index do |offer, index|
    username = offer.benchkiller_user&.username
    csv << [
      username.present? ? username : 'No username',
      offer.message.text,
      offer.tags.map(&:title).join(','),
      offer.created_at.strftime('%d.%m.%Y %H:%M')
    ]
    print "#{index}\r"
  end
end
