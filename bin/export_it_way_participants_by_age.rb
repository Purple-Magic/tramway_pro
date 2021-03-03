require 'csv'

age = 16

CSV.open('list.csv', 'w') do |csv|
  participants = Tramway::Event::Participant.where project_id: 2
  participants.each do |participant|
    if participant.values.present?
      begin
        birth_date = participant.values['Дата рождения']&.to_datetime
        if birth_date.present?
          difference = (Time.new(2020, 10, 23) - birth_date.to_time) / 3600 / 24 / 365
          if difference > age
            email = participant.values['Email']
            if email.present?
              csv << [
                "#{participant.values['Фамилия']} #{participant.values['Имя']} #{participant.values['Отчество']}",
                email
              ]
            end
          end
        end
      rescue StandardError => e
        puts "#{e}"
        puts "#{participant.values['Дата рождения']}"
      end
    end
  end
end
