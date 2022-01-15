# frozen_string_literal: true

class Benchkiller::Api::ApplicationController < ::Tramway::Api::ApplicationController
  before_action :authenticate_benchkiller_user
  include ::Benchkiller::Concerns

  def authenticate_for(entity_class)
    getter_name = "current_#{entity_class.to_s.parameterize.underscore}"
    define_current_entity_getter(entity_class, getter_name)
    public_send(getter_name)
  end

  def authenticate_benchkiller_user
    head(:unauthorized) unless authenticate_for Benchkiller::User
  end
end
