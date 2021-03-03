count = Tramway::Event::Event.find(3).participants.active.where.not(participation_state: :rejected).map do |p|
  p if p.values&.dig('Дата рождения').present? && TimeDifference.between(Time.now.to_date, p.values['Дата рождения'].to_date).in_years < 18
end.compact.count
puts "Количество возможных несовершеннолетних участников #{count}"
