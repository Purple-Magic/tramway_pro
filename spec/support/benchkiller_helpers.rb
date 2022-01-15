module BenchkillerHelpers
  def benchkiller_i18n_scope(*keys)
    I18n.t(keys.join('.'), scope: 'benchkiller.bot')
  end
end
