class FindMeds::Drug < ApplicationRecord
  ATTRIBUTES = {
    name: 'Name',
    comment: 'Комментарий',
    patent: 'Запатентовано ли название сейчас?',
  }

  PATENT_VALUES = {
    "Запатентовано" => :patented,
    "Не запатентовано или патент истёк" => :not_patented
  }

  enumerize :patent, in: [ :patented, :not_patented ], default: :patented
end
