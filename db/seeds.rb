projects = [
  { title: 'МБУ ДО ДЮСШ Ленинского района', description: 'Спортивная школа №5', url: 'sportschool-ulsk.test' },
  { title: 'IT Way', description: 'IT Way', url: 'it-way.test' }
]

projects.each do |project|
  p = Project.find_or_create_by! url: project[:url]
  p.update! project
end
