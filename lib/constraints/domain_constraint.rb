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
end
