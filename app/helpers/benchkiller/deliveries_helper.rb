module Benchkiller::DeliveriesHelper
  def deliveries_title
    content_for :title do
      "#{t('.title')} | Benchkiller"
    end
  end
end
