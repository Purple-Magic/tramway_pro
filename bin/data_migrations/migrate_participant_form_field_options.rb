Tramway::Event::ParticipantFormField.all.each_with_index do |field, index|
  if field.options != '' && !field.options.is_a?(Hash)
    if field.options.is_a? Integer
      field.update! options: {}
    else
      field.update! options: JSON.parse(field.options)
    end
  end
  print "#{index}/r"
end
