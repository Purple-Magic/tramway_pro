module BenchkillerHelpers
  def benchkiller_i18n_scope(*keys, **attributes)
    I18n.t(keys.join('.'), scope: 'benchkiller.bot', **attributes)
  end
end
