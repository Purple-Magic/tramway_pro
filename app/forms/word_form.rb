class WordForm < Tramway::Core::ApplicationForm
  properties :main, :synonims, :description

  def initialize(obj)
    super(obj).tap do
      form_properties main: :string,
        synonims: :string,
        description: :ckeditor
    end
  end

  def synonims=(value)
    super value.split(',')
  end
end
