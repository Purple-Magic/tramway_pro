# frozen_string_literal: true

class Admin::Television::VideoForm < Tramway::ApplicationForm
  properties :title, :file, :project_id, :remote_file_path

  def initialize(object)
    super(object).tap do
      form_properties title: :string,
        file: :default,
        remote_file_path: :string
    end
  end
end
