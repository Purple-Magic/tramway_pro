class Podcasts::Episodes::Montage::ConvertService < Podcasts::Episodes::BaseService
  attr_reader :episode

  def initialize(episode)
    @episode = episode
  end

  def call
    convert
  end

  private

  def convert
    converted_file.tap do |filename|
      if episode.file.path.split('.').last == 'ogg'
        command = write_logs(convert_to(:mp3, input: episode.file.path, output: filename))
        run command
      end

      episode.convert!
    end
  end

  def converted_file
    (episode.file.present? ? episode.file.path.split('.')[0..].join('.') : '') + '.mp3'
  end
end
