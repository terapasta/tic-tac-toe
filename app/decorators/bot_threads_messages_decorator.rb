class BotThreadsMessagesDecorator < Draper::CollectionDecorator
  include CsvGeneratable

  def to_csv(encoding: :utf8)
    headers = [:chat_id, :id, :speaker, :body, :answer_failed, :rating_level, :created_at, :user_agent]
      .map{|x| Message.human_attribute_name x}
    super(encoding: encoding, header_columns: headers) do |csv, chat|
      #chatオブジェクトのorderbyとlimitは無効。superのto_csv内で行われているfind_eachで無視される為。
      put_rows_to_csv(csv, chat)
    end
  end

  def put_rows_to_csv(csv, chat)
    return if chat.messages.length <= 1
    chat.messages.each do |message|
      csv << [
        chat.id,
        message.id,
        speaker_with_profile(message),
        message.body,
        message.answer_failed? ? '失敗' : '',
        level_with_reasons(message),
        message.created_at,
        message.user_agent
      ]
    end
  end

  private
    def speaker_with_profile(message)
      return message.speaker if message.bot? || message.chat.guest_user.nil?
      [
        message.speaker.to_s,
        *message.chat.guest_user.attributes.slice('name', 'email').values
      ].join(' ')
    end

    def level_with_reasons(message)
      return '' if message.rating.blank?
      [
        message.rating.level,
        *message.bad_reasons.pluck(:body)
      ].compact.join("\n")
    end
end
