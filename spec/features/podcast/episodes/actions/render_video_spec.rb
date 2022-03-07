require 'rails_helper'

describe 'Render video' do
  before { move_host_to red_magic_host }

  let!(:episode) do
    podcast = create :podcast, project_id: red_magic_id, podcast_type: :sample
    create :podcast_episode, podcast: podcast, project_id: red_magic_id
  end

  it 'sends command to a remote server' do
    command_1 = "ssh root@82.148.30.250 \"mkdir podcast_engine/#{episode.id}\""
    command_2 = "ssh root@82.148.30.250 \"nohup /bin/bash -c 'ffmpeg -y -loop 1 -i /root/podcast_engine/#{episode.id}/temp.png -i /root/podcast_engine/#{episode.id}/sound.mp3 -c:v libx264 -tune stillimage -c:a aac -pix_fmt yuv420p -shortest -strict -2 /root/podcast_engine/#{episode.id}/full_video.mp4 && curl -X PATCH red-magic.ru/red_magic/api/v1/podcast/episodes/#{episode.id}/video_is_ready?video_type=full_video' &\""
    command_3 = "scp #{episode.cover.path} root@82.148.30.250:/root/podcast_engine/#{episode.id}/"
    command_4 = "scp #{episode.ready_file.path} root@82.148.30.250:/root/podcast_engine/#{episode.id}/"

    expect_any_instance_of(Kernel).to receive(:system).with(command_1)
    expect_any_instance_of(Kernel).to receive(:system).with(command_2)
    expect_any_instance_of(Kernel).to receive(:system).with(command_3)
    expect_any_instance_of(Kernel).to receive(:system).with(command_4)

    Podcasts::RenderVideoWorker.new.perform episode.id
  end
end
