class PurpleMagicDecorator < Tramway::Core::ApplicationDecorator
  def title
    object.public_name
  end
end
