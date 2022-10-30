class ItWay::PeopleController < ApplicationController
  def index
  end

  def show
    @person = ItWay::PersonDecorator.new ItWay::Person.find params[:id]
  end
end
