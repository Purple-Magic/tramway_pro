require 'csv'

table = CSV.read('companies.csv')
table.each_with_index do |row, index|
  company = Benchkiller::Company.active.find_by title: row[1]
  unless company.present?
    Benchkiller::Company.create! title: row[1],
      company_url: row[3],
      portfolio_url: row[4],
      email: row[5],
      phone: row[6],
      place: row[15],
      regions_to_cooperate: row[16],
      review_state: row[17] == 't' ? :approved : :unviewed,
      project_id: 7
    puts "Created #{row[1]}"
  end
  print "#{index} of #{table.count}\r"
end
