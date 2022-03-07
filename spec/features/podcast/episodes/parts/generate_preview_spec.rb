# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

describe 'Generate part preview' do
  before { move_host_to red_magic_host }

  let!(:episode) do
    podcast = create :podcast, project_id: red_magic_id
    create :podcast_episode, podcast: podcast, project_id: red_magic_id
  end
  let(:begin_time) { '00:01:00' }
  let(:end_time) { '00:01:30' }

  let(:begin_time_10_seconds_before) { '00:00:50' }
  let(:end_time_10_seconds_after) { '00:01:40' }

  it 'should generate preview of a part' do
    visit '/admin'
    fill_in 'Email', with: "admin#{red_magic_id}@email.com"
    fill_in 'Пароль', with: '123456'
    click_on 'Войти', class: 'btn-success'

    click_on 'Подкасты'
    click_on episode.podcast.title
    sleep 1
    click_on episode.title
    click_on 'Добавить вырезанные части'

    fill_in 'record[begin_time]', with: begin_time
    fill_in 'record[end_time]', with: end_time
    click_on 'Сохранить'

    click_on "#{begin_time}-#{end_time}"

    assert_equal :podcast, Podcasts::Episodes::Parts::PreviewWorker.queue
    part = Podcast::Episodes::Part.last
    concat_preview_data_output = "#{episode.prepare_directory}/#{part.class}_#{part.id}_preview_concated_parts.mp3"
    before_file_path = "#{episode.prepare_directory}/#{part.class}_#{part.id}_preview_before.mp3"
    after_file_path = "#{episode.prepare_directory}/#{part.class}_#{part.id}_preview_after.mp3"
    log_file_path = "#{Rails.root}/log/render-test.log"
    render_command = lambda do |time1, time2, file_path|
      "ffmpeg -y -i .mp3 -b:a 320k -c copy -ss #{time1} -to #{time2} #{file_path} 2> #{log_file_path}"
    end
    before_file_render_command = render_command.call begin_time_10_seconds_before, begin_time, before_file_path
    after_file_render_command = render_command.call end_time, end_time_10_seconds_after, after_file_path
    concat_files_render_command = command name: :concat_2_files,
      before_file_path: before_file_path,
      after_file_path: after_file_path,
      concat_preview_data_output: concat_preview_data_output,
      log_file_path: log_file_path

    expect(Podcasts::Episodes::Parts::PreviewWorker).to have_enqueued_sidekiq_job(Podcast::Episodes::Part.last.id,
      concat_preview_data_output, before_file_render_command, after_file_render_command, concat_files_render_command)
  end
end
