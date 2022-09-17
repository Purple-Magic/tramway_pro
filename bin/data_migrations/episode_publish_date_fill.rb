Podcast.find(2).episodes.each do |episode|
  publish_date = if episode.public_title.present?
                   new_date = begin
                                episode.public_title.split(' ').last.to_datetime
                              rescue StandardError => e
                                episode.created_at
                              end
                   episode.update! public_title: episode.public_title.split(' ')[0..-5].join(' ')
                   new_date
                 else
                   episode.created_at
                 end

  episode.update! publish_date: publish_date
end
