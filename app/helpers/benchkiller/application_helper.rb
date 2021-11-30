# frozen_string_literal: true

module Benchkiller::ApplicationHelper
  def signed_in?
    session['benchkiller/user_id'].present?
  end

  CONTAINER_FLUID_PAGES = [
    { controller: 'benchkiller/web/offers', action: :index }
  ].freeze

  def container_fluid?
    CONTAINER_FLUID_PAGES.map do |path|
      current_page? path
    end.include? true
  end
end
