# frozen_string_literal: true

module ProjectsHelper
  class << self
    def projects
      Project.all.map &:url
    end

    def set_host(host)
      Capybara.app_host = 'http://' + host
    end
  end
end
