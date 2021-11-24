class Admin::Benchkiller::CollationForm < Tramway::Core::ApplicationForm
  properties :project_id, :state, :main, :words

  def initialize(object)
    super(object).tap do
      form_properties main: :string,
        words: {
        type: :string,
        input_options: {
          placeholder: 'введите все сопоставления этого слова через запятую и без пробелов'
        }
      }
    end
  end

  def submit(params)
    params[:words] = params[:words].split(',')
    super
  end
end
