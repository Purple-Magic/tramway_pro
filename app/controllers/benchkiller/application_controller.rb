# frozen_string_literal: true

class Benchkiller::ApplicationController < ApplicationController
  include ::Benchkiller::Concerns
  include ::Benchkiller::RegionsConcern
end
