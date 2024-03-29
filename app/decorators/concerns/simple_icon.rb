# frozen_string_literal: true

module SimpleIcon
  def simple_icon(name)
    url = "https://cdn.jsdelivr.net/npm/simple-icons@3.13.0/icons/#{name}.svg"

    raw URI.open(url).string.sub('<svg', '<svg style="width: 25px;" fill="#fff"')
  end
end
