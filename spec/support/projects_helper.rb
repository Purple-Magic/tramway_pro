# frozen_string_literal: true

module ProjectsHelper
  class << self
    def projects
      Project.all
    end

    def move_host_to(host)
      Capybara.app_host = 'http://' + host
    end
  end

  def it_way_id
    Project.where(url: 'it-way.test').first.id
  end

  def it_way_host
    'it-way.test'
  end

  def projects_names
    %i[it_way]
  end
end
