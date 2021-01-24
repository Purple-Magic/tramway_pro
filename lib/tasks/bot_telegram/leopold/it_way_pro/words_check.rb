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
            Word.active.where(main: word.downcase) + (Word.active.select do |record|
              record.synonims&.include? word.downcase
            end)
          end.flatten.uniq
        end
      end
    end
  end
end
