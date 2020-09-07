module ChatQuestUlsk::BotAnswers
  def expecting_answers(game)
    if game&.current_position.present?
      ChatQuestUlsk::Message.find_by(area: game.area, position: game.current_position).answer
    end
  end
end
