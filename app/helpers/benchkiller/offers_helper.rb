module Benchkiller::OffersHelper
  def offers_title
    content_for :title do
      "#{t(params[:collection], scope: [:collections, 'benchkiller/offer'])} | Benchkiller"
    end
  end
end
