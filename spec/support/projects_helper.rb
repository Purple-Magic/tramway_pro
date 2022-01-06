# frozen_string_literal: true

module ProjectsHelper
  class << self
    def projects
      Project.all
    end

    def projects_instead_of(*names)
      Project.where.not(url: (names.map { |name| "#{name}.test" }))
    end
  end

  def it_way_id
    Project.where(url: 'it-way.test').first.id
  end

  def kalashnikovisme_id
    Project.where(url: 'kalashnikovisme.test').first.id
  end

  def it_way_host
    'it-way.test'
  end

  def red_magic_id
    Project.where(url: 'red-magic.test').first.id
  end

  def red_magic_host
    'red-magic.test'
  end

  def projects_names
    %i[it_way]
  end

  def benchkiller_host
    'benchkiller.test'
  end

  def kalashnikovisme_host
    'kalashnikovisme.test'
  end
end
