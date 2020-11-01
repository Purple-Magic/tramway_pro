class Admin::PurpleMagicForm < Tramway::Core::ApplicationForm
  properties :favicon

  def initialize(object)
    super(object).tap do
      form_properties favicon: :file
    end
  end
end
