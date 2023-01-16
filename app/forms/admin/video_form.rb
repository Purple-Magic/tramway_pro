# frozen_string_literal: true

class Admin::VideoForm < Tramway::ApplicationForm
  properties :url, :project_id

  def initialize(object)
    super(object).tap do
      form_properties url: :string
    end
  end

  def url=(value)
    model.url = value
    model.save.tap do
      data = video_info value.split('/').last
      model.title = data[:title]
      model.description = data[:description]
      model.preview = data[:preview]
      model.save!
    end
  end

  include Youtube::Client

  def submit(params)
    super.tap do
      model.reload
    end
  end
end
