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
      command = write_logs(convert_to(:mp3, input: episode.file.path, output: episode.converted_file))
      run command, action: :convert
    end

    episode.convert!
  end
end
