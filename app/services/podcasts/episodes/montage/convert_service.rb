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
    episode.converted_file.tap do |filename|
      if episode.file.path.split('.').last == 'ogg'
        command = write_logs(convert_to(:mp3, input: episode.file.path, output: filename))
        run command, action: :convert
      end

      episode.convert!
    end
  end
end
