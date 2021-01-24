module BotTelegram
  module Leopold
    module ItWayPro
      module WordsCheck
        def words_to_explain(text)
          ['.', ',', '!', ':', ';', '(', ')', '@'].each do |symbol|
            text.gsub! symbol, ''
          end
          words = text.split(' ')
          words.map do |word|
            Word.find_records_by word, Word.active.approved
          end.flatten.uniq
        end
      end
    end
  end
end
