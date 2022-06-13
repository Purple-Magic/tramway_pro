c = Course.find ARGV[0]

c1 = c.dup
c1.save!

c.topics.each do |t|
  t1 = t.dup
  c1.topics << t1
  c1.save!

  t.lessons.each do |l|
    l1 = l.dup
    t1.lessons << l1
    t1.save!

    l.videos.each do |v|
      v1 = v.dup
      l1.videos << v1
      l1.save!
      v1.update! video_state: :ready
    end

    l.tasks.each do |task|
      task1 = task.dup
      l1.tasks << task1
      l1.save!
      task1.update! preparedness_state: :writing
    end
  end
end
