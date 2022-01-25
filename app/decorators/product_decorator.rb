class ProductDecorator < ApplicationDecorator
  delegate_attributes :title

  decorate_association :tasks

  include Concerns::TimeLogsTable

  class << self
    def collections
      [ :all ]
    end

    def list_attributes
      []
    end

    def show_attributes
      [ :time_logs ]
    end

    def show_associations
      [ :tasks ]
    end
  end
end
