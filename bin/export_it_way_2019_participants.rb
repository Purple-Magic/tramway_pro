require 'csv'

CSV.open('list.csv', 'w') do |csv|
  event = Tramway::Event::Event.find 26
  event.participants.active.where(participation_state: :prev_approved).find_each do |participant|
    csv << [
      "#{participant.values['Фамилия']} #{participant.values['Имя']} #{participant.values['Отчество']}",
      participant.values['Дата рождения']
    ]
  end
end
