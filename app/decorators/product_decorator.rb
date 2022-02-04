class ProductDecorator < ApplicationDecorator
  delegate_attributes :title, :tech_name

  decorate_association :tasks

  include Concerns::TimeLogsTable

  class << self
    def collections
      [ :all ]
    end

    def list_attributes
      [ :time_logs ]
    end

    def show_attributes
      [ :tech_name, :time_logs ]
    end

    def show_associations
      [ :tasks ]
    end
  end
end
