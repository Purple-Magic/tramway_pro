#!/usr/bin/env ruby

require 'csv'
require 'colorize'
require 'pry'
require 'fileutils'

filename = ARGV[0]
times = CSV.read('bin/podcast/moments/moments.csv')
puts "Converting to mp3...".green
mp3_filename = filename.split('.')[0..-2].join('.') + '.mp3'
system "ffmpeg -i #{filename} #{mp3_filename}"
times.each_with_index do |time, index|
  hour = time[0].split(':')[0]
  minutes = time[0].split(':')[1]
  seconds = time[0].split(':')[2]
  begin_time = (DateTime.new(2020, 01, 01, hour.to_i, minutes.to_i, seconds.to_i) - 2.minutes).strftime '%H:%M:%S'
  end_time = time[0]
  directory = filename.split('.')[0..-2].join('.')
  FileUtils.mkdir_p directory
  command = "ffmpeg -i #{mp3_filename} -ss #{begin_time} -to #{end_time} -c copy #{directory}/part-#{index + 1}.mp3"
  puts command.green
  system command
end
