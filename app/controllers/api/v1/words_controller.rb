class Api::V1::WordsController < Api::V1::ApplicationController
  def index
    words = Word.active
    render json: words,
      each_serializer: WordSerializer,
      status: :ok
  end
end
