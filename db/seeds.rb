if Rails.env.development?
  Project.find_each do |project|
    project.update! url: project.url.gsub(/\..*$/, '.test')
  end
end
