module FillingForms
  def fill_form(form_name, attributes)
    forms[form_name].call attributes
  end

  def forms
    {
      admin_courses_screencast: model_forms[:screencast],
      skillbox_courses_screencast: model_forms[:screencast],
      slurm_courses_screencast: model_forms[:screencast]
    }.with_indifferent_access
  end

  def model_forms
    {
      screencast: lambda do |attributes|
        attributes.each do |pair|
          fill_in "record[#{pair[0]}]", with: pair[1] if pair[1].present?
        end
      end
    }
  end
end
