Courses::Comment.find_each do |comment|
  comment.update! associated_id: comment.video_id, associated_type: 'Courses::Video'
  print "Comment #{comment.id}\r"
end

Courses::Comment.find_each do |comment|
  puts "Comment video_id #{comment.video_id}; Associated: #{comment.associated_id}, #{comment.associated_type}"
end
