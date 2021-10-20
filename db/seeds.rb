# frozen_string_literal: true

if Rails.env.test? || Rails.env.development?
  Project.find_each do |project|
    project.update! url: project.url.gsub(/\..*$/, '.test')
  end
  Bot.find_each do |bot|
    bot.update! token: '2002248998:AAGiZfHKXfhuTl_sC2goM21BzN2ScCuP9hg'
  end
end
