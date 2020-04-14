class Admin::Listai::PageForm < Tramway::Core::ApplicationForm
  properties :number, :file

  association :book

  def initialize(object)
    super(object).tap do
      form_properties book: :association,
        number: :integer,
        file: :file
    end
  end
end
