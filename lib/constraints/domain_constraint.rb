class Constraints::DomainConstraint
  def initialize(domain)
    @domains = [domain].flatten
  end

  def matches?(request)
    ENV['PROJECT_URL'] = request.domain
    @domains.include? request.domain
  end
end
