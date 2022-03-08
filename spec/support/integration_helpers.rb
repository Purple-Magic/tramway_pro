# frozen_string_literal: true

module IntegrationHelpers
  def click_on_link_by_href(href, options = {})
    button = find compile_attributes(href: href), options
    button.click
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

  private

  def compile_attributes(attributes = {})
    attributes.reduce('a') do |param, (key, value)|
      param += "[#{key}='#{value}']"
    end
  end
end
