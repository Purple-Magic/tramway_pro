# frozen_string_literal: true

class ApplicationRecord < Tramway::ApplicationRecord
  self.abstract_class = true
end

# IT'S HACK. REMOVE IT
class Tramway::Event::Event < Tramway::ApplicationRecord
  aasm do
    state :hack
  end
end

# IT'S HACK. REMOVE IT
class Tramway::Event::Participant < Tramway::ApplicationRecord
  aasm do
    state :hack
  end
end

# IT'S HACK. REMOVE IT
class Tramway::Page::Page < Tramway::ApplicationRecord
  aasm do
    state :hack
  end
end

# IT'S HACK. REMOVE IT
class Tramway::User < Tramway::ApplicationRecord
  aasm do
    state :hack
  end
end
