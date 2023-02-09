# frozen_string_literal: true

class Admin::Podcast::StarForm < Tramway::ApplicationForm
  properties :nickname, :link, :project_id, :vk, :twitter, :telegram, :instagram, :first_name, :last_name

  association :podcast

  def initialize(object)
    super(object).tap do
      form_properties podcast: :association,
        nickname: {
          type: :string,
          input_options: {
            placeholder: I18n.t('placeholders.podcast/star.nickname'),
            hint: I18n.t('hints.podcast/star.nickname')
          }
        },
        first_name: {
          type: :string,
          input_options: {
            placeholder: I18n.t('placeholders.podcast/star.first_name'),
            hint: I18n.t('hints.podcast/star.first_name')
          }
        },
        last_name: {
          type: :string,
          input_options: {
            placeholder: I18n.t('placeholders.podcast/star.last_name'),
            hint: I18n.t('hints.podcast/star.last_name')
          }
        },
        link: {
          type: :string,
          input_options: {
            placeholder: I18n.t('placeholders.podcast/star.link'),
            hint: I18n.t('hints.podcast/star.link')
          }
        },
        twitter: {
          type: :string,
          input_options: {
            placeholder: I18n.t('placeholders.podcast/star.twitter'),
            hint: I18n.t('hints.podcast/star.twitter')
          }
        },
        telegram: {
          type: :string,
          input_options: {
            placeholder: I18n.t('placeholders.podcast/star.telegram'),
            hint: I18n.t('hints.podcast/star.telegram')
          }
        },
        instagram: {
          type: :string,
          input_options: {
            placeholder: I18n.t('placeholders.podcast/star.instagram'),
            hint: I18n.t('hints.podcast/star.instagram')
          }
        },
        vk: {
          type: :string,
          input_options: {
            placeholder: I18n.t('placeholders.podcast/star.vk'),
            hint: I18n.t('hints.podcast/star.vk')
          }
        }
    end
  end
end
