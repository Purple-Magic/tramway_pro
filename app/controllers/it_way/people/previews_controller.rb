class ItWay::People::PreviewsController < Tramway::Core::ApplicationController
  def show
    @person = ItWay::PersonDecorator.new ItWay::Person.find params[:id]
  end
end
