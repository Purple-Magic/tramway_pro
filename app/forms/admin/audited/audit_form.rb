class Admin::Audited::AuditForm < Tramway::Core::ApplicationForm
  properties :username, :action, :audited_changes, :version, :comment, :remote_address, :request_uuid

  def initialize(object)
    super(object).tap do
      # Here is the mapping from model attributes to simple_form inputs.
      # form_properties title: :string,
      #   logo: :file,
      #   description: :ckeditor,
      #   games: :association,
      #   date: :date_picker,
      #   text: :text,
      #   birth_date: {
      #     type: :default,
      #     input_options: {
      #       hint: 'It should be more than 18'
      #     }
      #   }
      form_properties username: :string,
                      action: :string,
                      audited_changes: :text,
                      version: :integer,
                      comment: :string,
                      remote_address: :string,
                      request_uuid: :string
    end
  end
end
