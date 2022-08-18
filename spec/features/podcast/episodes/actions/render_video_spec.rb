# # frozen_string_literal: true

# require 'rails_helper'

# describe 'Render video' do
#   before { move_host_to it_way_host }

#   let!(:episode) do
#     podcast = create :podcast, project_id: it_way_id, podcast_type: :sample
#     create :podcast_episode, podcast: podcast, project_id: it_way_id, cover: generate(:image_as_file),
#       ready_file: generate(:sound_as_file)
#   end

#   it 'sends command to a remote server' do
#     connect_info = 'root@82.148.30.250'
#     commands = [
#       ssh_run(connect_info, "mkdir podcast_engine/#{episode.id}"),
#       ssh_run(
#         connect_info,
#         command(name: :nohup, command: command(name: :merge_image_and_audio, episode_id: episode.id.to_s))
#       ),
#       scp_run(episode.cover.path, connect_info, "/root/podcast_engine/#{episode.id}/"),
#       scp_run(episode.ready_file.path, connect_info, "/root/podcast_engine/#{episode.id}/")
#     ]

#     commands.each do |command|
#       expect_any_instance_of(Kernel).to receive(:system).with(command)
#     end

#     sleep 1
#     episode.reload

#     Podcasts::RenderVideoWorker.new.perform episode.id
#   end
# end
