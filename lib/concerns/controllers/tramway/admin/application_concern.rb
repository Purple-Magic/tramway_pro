# frozen_string_literal: true
# module Concerns::Controllers
#  module Tramway::Admin::ApplicationConcern
#    def available_models_given_with_permissions?
#      constraint = ::Constraints::DomainConstraint.new(ENV['PROJECT_URL'])
#      ::Tramway::Admin.available_models(permission: constraint.engine_loaded) &&
#        params[:model].in?(::Tramway::Admin.available_models(constraint.engine_loaded).map(&:to_s))
#    end
#
#    def singleton_models_given_with_permissions?
#      constraint = ::Constraints::DomainConstraint.new(ENV['PROJECT_URL'])
#      ::Tramway::Admin.singleton_models(permission: constraint.engine_loaded) &&
#        params[:model].in?(::Tramway::Admin.singleton_models(constraint.engine_loaded).map(&:to_s))
#    end
#  end
# end

#::Tramway::Admin::ApplicationController.send :include, Concerns::Controllers::Tramway::Admin::ApplicationConcern
