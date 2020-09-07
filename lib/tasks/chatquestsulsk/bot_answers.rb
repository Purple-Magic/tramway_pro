module ChatQuestUlsk::BotAnswers
  def expecting_answers(game)
    if game&.current_position.present?
      ChatQuestUlsk::Message.find_by position: game.current_position
    end
  end
end
