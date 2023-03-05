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
    extension = episode.file.path.split('.').last

    if extension == 'ogg'
      filename = episode.file.path.split('.')[0..-2].join('.')

      episode.update converted_file: filename
    end

    episode.converted_file.tap do |filename|
      command = write_logs(convert_to(:mp3, input: episode.file.path, output: filename))
      run command, action: :convert

      episode.convert!
    end
  end
end
