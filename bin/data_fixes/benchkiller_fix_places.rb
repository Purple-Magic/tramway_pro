Benchkiller::Company.find_each.with_index do |company, index|
  begin
    company.update! regions_to_cooperate: company.data&.dig( 'regions_to_cooperate' )&.split(',')
    company.update! regions_to_except: company.data&.dig( 'regions_to_except' )&.split(',')
    company.update! place: company.data&.dig( 'place' )&.split(',')
  rescue StandardError => e
    puts e.message
  end

  print "#{index}\r"
end
