require 'csv'

CSV.open('list.csv', 'w') do |csv|
  participants = Tramway::Event::Participant.where project_id: 2
  participants.each do |participant|
    if participant.values.present?
      begin
        birth_date = participant.values['Дата рождения']&.to_datetime
        if birth_date.present? && (DateTime.new(2020, 10, 23) - birth_date) < 16.years
          email = participant.values['Email']
          if email.present?
          csv << [
            "#{participant.values['Фамилия']} #{participant.values['Имя']} #{participant.values['Отчество']}",
            email
          ]
          end
        end
      rescue StandardError => e
        puts "#{e}"
        puts "#{participant.values['Дата рождения']}"
      end
    end
  end
end
