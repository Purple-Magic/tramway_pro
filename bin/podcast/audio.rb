beg = "ffmpeg -i ../Music/begin.wav"
filter = "-filter_complex"
samples_count = 144
audios = ''
samples_count.times do |i|
  audios += '-i ../Music/sample.wav '
end
finish = "-i ../Music/finish.wav "
parts = ""
(samples_count + 2).times do |i|
  parts += "[#{i}:0]"
end
concatination = "concat=n=#{samples_count + 2}:v=0:a=1[out]' -map '[out]' -b:a 320k podcast.mp3"

puts "#{beg} #{audios} #{finish} #{filter} '#{parts} #{concatination}"
