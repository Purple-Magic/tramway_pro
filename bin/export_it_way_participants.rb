require 'csv'

participants = Tramway::Event::Participant.active
participants.reduce([]) do |csv, p|
end

association = {
  3 => {
    birth_date: 4,
    link: 9,
    org: 10,
    where: 15
  },
  4 => {
    org: 19,
    where: 20,
    link: 22
  },
  5 => {
    org: 26,
    where: 27,
    link: 29
  },
  6 => {
    org: 34,
    where: 35,
    link: 36
  },
  7 => {
    org: 41,
    where: 43,
    link: 44
  },
  8 => {
    org: 49,
    link: 50,
    where: 51
  },
  17 => {
    org: 60,
    where: 61,
    link: 62
  },
  18 => {
    org: 76,
    where: 77,
    link: 78
  },
  21 => {
    org: 84,
    where: 85,
    link: 86
  },
  23 => {
    org: 91,
    where: 92,
    link: 93
  },
  9 => {
    org: 98,
    where: 99,
    link: 100
  },
  24 => {
    org: 105,
    where: 106,
    link: 107
  },
  22 => {
    org: 112,
    where: 113,
    link: 114
  },
  26 => {
    org: 121,
    link: 123,
    where: 124,
    birth_date: 120
  },
  25 => {
    org: 132,
    where: 133,
    link: 134
  },
  27 => {
    where: 140,
    org: 142,
    link: 143
  },
  28 => {
    where: 149,
    org: 148,
    link: 150
  },
}

CSV.open('list.csv', 'w') do |csv|
  Tramway::Event::Event.active.find_each do |event|
    next if event.id == 19
    event.participants.active.find_each do |participant|
      form_fields = association[event.id]
      csv << [ event.title ] + [:org, :where, :link, :birth_date].map do |key|
        if form_fields[key]
          form_field = event.participant_form_fields.find form_fields[key] 
          participant.values[form_field.title]
        end
      end
    end
  end
end
