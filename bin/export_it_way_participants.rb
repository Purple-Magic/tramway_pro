require 'csv'

CSV.open('list.csv', 'w') do |csv|
  Tramway::Event::Event.find(3).participants.active.where(participation_state: :prev_approved).each do |p|
    full_name = "#{p.values['Фамилия']} #{p.values['Имя']} #{p.values['Отчество']}"
    csv << [ full_name, p.values['Телефон'], p.values['Ссылка на страницу ВКонтакте'], p.values['Населённый пункт'], p.values['Направление на Форуме (подробности появятся позже на этой странице ниже)']]
  end
end
