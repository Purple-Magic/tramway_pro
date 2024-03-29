# frozen_string_literal: true

class Admin::Blogs::LinkForm < Tramway::ApplicationForm
  properties :url, :image, :title, :lead, :project_id, :link_type

  def initialize(object)
    super(object).tap do
      form_properties title: :string,
        lead: :text,
        link_type: :default,
        url: :string,
        image: :file
    end
  end
end
