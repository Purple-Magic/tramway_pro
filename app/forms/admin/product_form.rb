class Admin::ProductForm < Tramway::Core::ApplicationForm
  properties :title, :project_id, :tech_name, :chat_id

  def initialize(object)
    super(object).tap do
      form_properties title: :string,
        tech_name: :string,
        chat_id: :string
    end
  end
end
