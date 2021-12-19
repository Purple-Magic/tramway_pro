Rails.application.eager_load!
exceptions = [
  "PgSearch::Document",
  "Audited::Audit",
  "Tramway::Event::Event::HABTM_Places",
  "Tramway::Event::Place::HABTM_Events",
  "Benchkiller::Offer::HABTM_Tags",
  "Benchkiller::Tag::HABTM_Offers",
  "Ckeditor::Asset",
  "Ckeditor::AttachmentFile",
  "Ckeditor::Picture",
  "Shortener::ShortenedUrl"
]
ActiveRecord::Base.descendants.each do |model|
  next if model.to_s.in? exceptions
  next if model.to_s.include? "ApplicationRecord"
  puts model
  removed = model.where(state: :removed)
  count = removed.count
  removed.each_with_index do |rec, index|
    rec.update_column :deleted_at, rec.updated_at
    print "#{index} of #{count}\r"
  end
end
