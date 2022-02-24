# frozen_string_literal: true

class Benchkiller::Api::RegionsController < Benchkiller::Api::ApplicationController
  def index
    render json: regions,
      each_serializer: ::Benchkiller::RegionSerializer,
      include: '*',
      status: :ok
  end
end
