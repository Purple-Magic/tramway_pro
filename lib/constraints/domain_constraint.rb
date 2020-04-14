# frozen_string_literal: true

class Constraints::DomainConstraint
  def initialize(domain)
    @domains = [domain].flatten
    ENV['PROJECT_URL'] = domain
  end

  def matches?(request)
    ENV['PROJECT_URL'] = request.domain
    @domains.include? request.domain
  end

  def engine_loaded
    Settings[Rails.env][:engines][ENV['PROJECT_URL']]
  end

  def application_class
    Settings[Rails.env][:application_class][ENV['PROJECT_URL']]
  end

  def application_object
    Settings[Rails.env][:application][ENV['PROJECT_URL']]
  end
end
