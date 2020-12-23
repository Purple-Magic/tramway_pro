# frozen_string_literal: true

module MultiProjectConfigurationMiddleware
  class AuditMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      Audited::Audit.include MultiProjectCallbacks::AuditsConcern

      @app.call(env)
    end
  end
end

module MultiProjectCallbacks
  module AuditsConcern
    extend ActiveSupport::Concern

    included do
      class << self
        def make_scope(expression, queries, index = 0)
          new_expression = if expression.is_a?(Class)
                             expression.where auditable_id: queries[index][:ids], auditable_type: queries[index][:auditable_type]
                           else
                             expression.or(where auditable_id: queries[index][:ids], auditable_type: queries[index][:auditable_type])
                           end
          if queries[index + 1].present?
            make_scope new_expression, queries, index + 1
          else
            new_expression
          end
        end
      end

      default_scope -> do
        project = Project.where(url: ENV['PROJECT_URL']).first
        types = pluck(:auditable_type).uniq
        queries = types.map do |model_name|
          begin
            ids = model_name.constantize.where(project_id: project.id).map &:id
            { auditable_type: model_name, ids: ids }
          rescue
            nil
          end
        end.compact
        make_scope Audited::Audit, queries
      end

      def project_id
        auditable.project_id
      end
    end
  end
end
