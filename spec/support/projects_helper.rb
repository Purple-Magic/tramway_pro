module ProjectsHelper
  class << self 
    def projects
      binding.pry
      Project.all.map &:url
    end

    def set_host(host)
      Capybara.app_host = 'http://' + host
    end
  end
end
