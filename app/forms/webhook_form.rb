class WebhookForm < Tramway::Core::ApplicationForm
  properties :service, :params, :headers
end
