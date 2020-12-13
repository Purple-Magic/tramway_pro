class BotDecorator < Tramway::Core::ApplicationDecorator
  delegate_attributes :title

  decorate_association :steps

  class << self
    def show_associations
      [ :steps ]
    end
  end
end
