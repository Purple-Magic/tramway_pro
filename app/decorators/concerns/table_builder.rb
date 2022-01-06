module Concerns::TableBuilder
  def th(&block)
    content_tag(:th) do
      yield
    end
  end

  def td(&block)
    content_tag(:td) do
      yield
    end
  end
end
