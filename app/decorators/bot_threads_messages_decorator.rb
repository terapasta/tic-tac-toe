class BotThreadsMessagesDecorator < Draper::CollectionDecorator
  include CsvGeneratable

  def to_csv(encoding: :utf8)
    super do |csv, chat|
      #chatオブジェクトのorderbyとlimitは無効。superのto_csv内で行われているfind_eachで無視される為。
      put_rows_to_csv(csv, chat)
    end
  end

  def put_rows_to_csv(csv, chat)
    chat.messages.order('id asc').each do |message|
      csv << [chat.id, message.id, message.speaker, message.body,
              message.answer_failed ? '失敗' : '',
              message.nothing? ? '' : message.rating,
              message.created_at]
    end
  end

  def as_tree_json
    map(&:as_tree_node_json)
  end

  def as_repo_json
    inject({}) { |result, qa|
      result[qa.id] = qa
      result
    }
  end
end
