require 'csv'

CSV.open('list.csv', 'w') do |csv|
  participants = Tramway::Event::Event.find(3).participants.active.where(participation_state: :prev_approved)
  participants.each_with_index do |p, index|
    full_name = "#{p.values['Фамилия'].strip} #{p.values['Имя'].strip} #{p.values['Отчество'].strip}"
    csv << [ full_name,
             p.values['Телефон'],
             p.values['Ссылка на страницу ВКонтакте'],
             p.values['Населённый пункт'],
             p.values['Направление на Форуме (подробности появятся позже на этой странице ниже)'],
             p.values['Дата рождения']
    ]
  end
end
