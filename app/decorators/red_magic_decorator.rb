class RedMagicDecorator < Tramway::Core::ApplicationDecorator
  def title
    object.public_name
  end
end
