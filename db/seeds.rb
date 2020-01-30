# frozen_string_literal: true

if Rails.env.test? || Rails.env.development?
  Project.find_each do |project|
    project.update! url: project.url.gsub(/\..*$/, '.test')
  end
end
