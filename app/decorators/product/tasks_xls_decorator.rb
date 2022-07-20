class Product::TasksXlsDecorator < Tramway::Export::Xls::ApplicationDecorator
  delegate_attributes :title

  class << self
    def filename
      'tasks.xls'
    end

    def sheet_name
      'Отчёт по задачам'
    end
  end

  def flexible_columns
    [{ title: -> { object.title } }] + object.product.time_logs.map(&:user).flatten.map do |user|
      { user.full_name => -> { TimeLog.time_logged_by(user, object) }  } 
    end
  end
end
