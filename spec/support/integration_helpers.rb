# frozen_string_literal: true

module IntegrationHelpers
  def click_on_link_by_href(href, options = {})
    button = find compile_attributes(href: href), options
    button.click
  end

  def click_on_save_button
    click_on 'Сохранить', class: 'btn-success'
  end

  def click_on_edit_button
    find('.btn.btn-warning', match: :first).click
  end

  def click_on_destroy_link_by_href(href, options = {})
    button = find compile_attributes(href: href, 'data-method' => :delete), options
    button.click
  end

  def click_on_check_box(text)
    find(:label, text: text).click
  end

  def click_on_check_box_by_id(id)
    find('input', id: id).click
  end

  def move_host_to(host)
    Capybara.app_host = "http://#{host}"
  end

  # :reek:FeatureEnvy disable
  def click_on_association_edit_button(object, association)
    current_path = Tramway::Admin::Engine.routes.url_helpers.record_path(object.id, model: object.class.name)
    edit_path = Tramway::Admin::Engine.routes.url_helpers.edit_record_path(
      association.id,
      model: association.class.name,
      redirect: current_path
    )
    click_on_link_by_href edit_path
  end

  # :reek:FeatureEnvy disable
  def click_on_association_destroy_button(object, association)
    current_path = Tramway::Admin::Engine.routes.url_helpers.record_path(object.id, model: object.class.name)
    destroy_path = Tramway::Admin::Engine.routes.url_helpers.record_path(
      association.id,
      model: association.class.name,
      redirect: current_path
    )
    click_on_destroy_link_by_href destroy_path
  end
  # :reek:FeatureEnvy enable

  private

  def compile_attributes(attributes = {})
    attributes.reduce('a') do |param, (key, value)|
      param + "[#{key}='#{value}']"
    end
  end
end
