# frozen_string_literal: true

if Rails.env.test? || Rails.env.development?
  Project.find_each do |project|
    project.update! url: project.url.gsub(/\..*$/, '.test')
  end
  Bot.find_each do |bot|
    bot.update! token: '2002248998:AAGiZfHKXfhuTl_sC2goM21BzN2ScCuP9hg'
  end
end

# Project.destroy_all
# project = Project.find_or_create_by! url: 'red-magic.test'

# Tramway::User.destroy_all
# email = 'kalashnikovisme@gmail.com'
# user = Tramway::User.create! email: email, password: '123', project_id: project.id

# Podcast.destroy_all
# podcast = Podcast.create! title: 'IT Way Podcast', project_id: project.id, podcast_type: :sample
# episode = Podcast::Episode.create! "podcast_id"=> podcast.id,
#  "title"=>nil,                                                                                                         
#  "number"=>13,                                                                                                         
#  "season"=>nil,                                                                                                        
#  "description"=>"",                                                                                                    
#  "published_at"=>nil,                                                                                                  
#  "image"=>nil,                                                                                                         
#  "explicit"=>nil,                                                                                                      
#  "project_id"=>project.id,                                                                                                      
#  "montage_state"=>"converted",
#  "file_url"=>nil,
#  "duration"=>nil,
#  "cover"=>nil,
#  "ready_file"=>nil,
#  "trailer"=>nil,
#  "full_video"=>nil,
#  "trailer_video"=>nil,
#  "record_time"=>nil,
#  "public_title"=>"Почему ShowGirls хороший фильм?",
#  "montage_process"=>"default",
#  "deleted_at"=>nil,
#  "story_cover"=>nil,
#  "story_trailer_video"=>nil,
#  "publish_date"=>nil
