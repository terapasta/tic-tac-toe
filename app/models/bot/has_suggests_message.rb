module Bot::HasSuggestsMessage
  extend ActiveSupport::Concern

  module SuggestMessage
    Placeholder = '{question}'
    Default = "#{Placeholder}についてですね。\nどのような質問ですか？\n以下から選択して下さい。"
  end

  included do
    after_initialize :set_default_has_suggests_message
  end

  def render_has_suggests_message(question)
    has_suggests_message
      .sub(SuggestMessage::Placeholder, "「#{question}」")
      .gsub(SuggestMessage::Placeholder, '')
  end

  private
    def set_default_has_suggests_message
      self.has_suggests_message =
        has_suggests_message.presence || SuggestMessage::Default
    end
end
