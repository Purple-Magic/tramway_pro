module TramwayProClassMethods
  def before_render(method, **options)
    @before_render_methods ||= {}
    @before_render_methods[options[:only]] ||= []
    @before_render_methods[options[:only]] << method
  end

  def before_render_methods
    @before_render_methods || {}
  end
end

module TramwayProObjectMethods
  def self.included(klass)
    klass.extend(TramwayProClassMethods)
  end

  def render(*args)
    self.class.before_render_methods[action_name.to_sym]&.each do |method|
      send method
    end
    super
  end
end

Tramway::ApplicationController.include TramwayProObjectMethods
Tramway::Conference::Web::WelcomeController.include TramwayProObjectMethods
Tramway::RecordsController.include TramwayProObjectMethods
Tramway::SingletonsController.include TramwayProObjectMethods
