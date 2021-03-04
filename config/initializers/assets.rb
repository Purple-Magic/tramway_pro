# frozen_string_literal: true

Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.paths << Rails.root.join('node_modules')
Rails.application.config.assets.precompile += [
  '*.jpg',
  '*.png',
  '*.js',
  '*.ttf',
  '*.otf',
#  'node_modules/*',
  'engineervol/web/welcome.css',
  'purple_magic/web/welcome.css',
  'red_magic/web/welcome.css',
  'red_magic/web/projects.css',
  'it_way/podcasts/highlights.css'
]
