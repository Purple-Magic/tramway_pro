module MultiProjectCallbacks
  extend ActiveSupport::Concern

  included do
    actions = [ :index ]
    actions.each do |action|
      after_action "after_#{action}".to_sym, only: action
    end

    after_action :after_index, only: :index

    def after_index
      project = Project.where(url: ENV['PROJECT_URL']).first
      @blocks = @blocks.where(project_id: project.id)
    end
  end
end
