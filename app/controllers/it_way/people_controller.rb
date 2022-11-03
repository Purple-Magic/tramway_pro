class ItWay::PeopleController < Tramway::Core::ApplicationController
  def index
  end

  def show
    @person = ItWay::PersonDecorator.new ItWay::Person.find params[:id]
  end
end
