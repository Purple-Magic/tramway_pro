# frozen_string_literal: true

require 'rails_helper'

describe 'Render video' do
  before { move_host_to red_magic_host }

  let!(:episode) do
    podcast = create :podcast, project_id: red_magic_id, podcast_type: :sample
    create :podcast_episode, podcast: podcast, project_id: red_magic_id
  end

  it 'sends command to a remote server' do
    connect_info = 'root@82.148.30.250'
    command_1 = ssh_run connect_info, "mkdir podcast_engine/#{episode.id}"
    command_2 = ssh_run connect_info,
      command(name: :nohup, command: command(name: :merge_image_and_audio, episode_id: episode.id.to_s))
    command_3 = scp_run episode.cover.path, connect_info, "/root/podcast_engine/#{episode.id}/"
    command_4 = scp_run episode.ready_file.path, connect_info, "/root/podcast_engine/#{episode.id}/"

    expect_any_instance_of(Kernel).to receive(:system).with(command_1)
    expect_any_instance_of(Kernel).to receive(:system).with(command_2)
    expect_any_instance_of(Kernel).to receive(:system).with(command_3)
    expect_any_instance_of(Kernel).to receive(:system).with(command_4)

    Podcasts::RenderVideoWorker.new.perform episode.id
  end
end
