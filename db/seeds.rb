# frozen_string_literal: true

if Rails.env.test? || Rails.env.development?
  Project.find_each do |project|
    project.update! url: project.url.gsub(/\..*$/, '.test')
  end
  Bot.find_each do |bot|
    bot.update! token: '1468112382:AAEebxrV8YNkcZYOy3ium7aN066LEAe7Mpk'
  end
end
