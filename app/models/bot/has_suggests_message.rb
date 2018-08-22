module Bot::HasSuggestsMessage
  extend ActiveSupport::Concern

  module SuggestMessage
    Placeholder = '{question}'
    Default = "#{Placeholder}についてですね。 どのような質問ですか？ 以下から選択するか、もう少し詳しい内容を入力していただけますか？\n\nもし回答が見つからない場合は、 example@my-ope.net 宛にご質問いただければ、後ほど担当者からメール致します。"
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
