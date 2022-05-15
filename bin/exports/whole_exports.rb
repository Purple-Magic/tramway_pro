def build_attributes(object, ignore_keys: nil, has_name: true, files: [])
  attributes = object.attributes.reduce({}) do |hash, (key, value)|
    hash ||= {}
    case key
    when 'id', *ignore_keys
      hash
    when 'created_at', 'updated_at', 'deleted_at', 'start_date', 'finish_date'
      hash.merge! key => value.to_s
    when *files
      hash.merge! "remote_#{key}_url" => value.url
    else
      hash.merge! key => value
    end
  end

  if has_name
    attributes.merge name: object.name
  else
    attributes
  end
end
