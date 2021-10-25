require 'csv'

table = CSV.read('companies.csv')
table.each_with_index do |row, index|
  Benchkiller::Company.create! title: row[1],
    company_url: row[3],
    portfolio_url: row[4],
    email: row[5],
    phone: row[6],
    place: row[15],
    regions_to_cooperate: row[16],
    project_id: 7
  print "#{index} of #{table.count}\r"
end
