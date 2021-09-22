module Podcast::PathManagementConcern
  def update_output(suffix, output)
    (output.split('.')[0..-2] + [suffix, :mp3]).join('.')
  end
end
