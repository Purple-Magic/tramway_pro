require 'csv'

data = CSV.parse(File.read('election_list.csv'))
puts data.count
data.each_with_index do |candidate, index|
  Elections::Candidate.create! full_name: candidate[0], area: candidate[1], consignment: candidate[2], project_id: Project.last.id
  print "#{index} of #{data.count}\r"
end
