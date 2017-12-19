class QuestionAnswer::CsvImporter
  ModeEncForUTF8 = 'r'
  ModeEncForSJIS = 'rb:Shift_JIS:UTF-8'

  class EmptyQuestionError < StandardError; end
  class EmptyAnswerError < StandardError; end

  attr_reader :succeeded, :current_row, :error_message

  def initialize(file, bot, options = {})
    @file = file
    @bot = bot
    @options = { is_utf8: false }.merge(options)
    @mode_enc = options[:is_utf8] ? ModeEncForUTF8 : ModeEncForSJIS
    @encoding = options[:is_utf8] ? Encoding::UTF_8 : Encoding::Shift_JIS
    @current_answer = nil
    @current_row = nil
    @succeeded = false
    @error_message = nil
  end

  def import
    csv_data = embed_record_id(parse)
    ActiveRecord::Base.transaction do
      csv_data.each do |import_param|
        topic_tag_names = import_param.delete(:topic_tag_names)

        # Q&Aのidを持っているか、idでレコードが見つかったら更新
        # それ以外は作成する
        question_answer = begin
          if import_param[:id].present? &&
            (qa = @bot.question_answers.find_by(id: import_param[:id]))
            qa.update!(import_param)
            qa
          else
            @bot.question_answers.create!(import_param)
          end
        end

        if topic_tag_names.present?
          target_topic_tags = @bot.topic_tags.where(name: topic_tag_names)
          new_topic_tags = target_topic_tags - question_answer.topic_tags
          data = new_topic_tags.map{ |t| { topic_tag_id: t.id } }
          question_answer.topic_taggings.create!(data)
        end
      end
    end
    @succeeded = true
  rescue EmptyQuestionError => e
    @error_message = '質問を入力してください'
  rescue EmptyAnswerError => e
    @error_message = '回答を入力してください'
  rescue => e
    Rails.logger.debug(e)
    Rails.logger.debug(e.backtrace.join("\n"))
  end

  def parse
    raw_data = FileReader.new(file_path: @file.path, encoding: @encoding).read
    CSV.new(raw_data).drop(1).each_with_index.inject({}) { |out, (row, index)|
      @current_row = index + 2
      data = detect_or_initialize_by_row(row)

      decision_branches = Array(out[data[:key]].try(:dig, :decision_branches_attributes))
      decision_branches.push(data[:decision_branch]) if data[:decision_branch].present?

      decision_branches = deep_merge_db(decision_branches)

      topic_tag_names = Array(out[data[:key]].try(:dig, :topic_tag_names))
      topic_tag_names += Array(data[:topic_tag_names])

      out[data[:key]] = {
        id: data[:id],
        question: data[:question],
        answer: data[:answer],
        decision_branches_attributes: decision_branches,
        topic_tag_names: topic_tag_names,
      }
      out
    }.values
  end

  ##
  # 全てのnodeをチェックして全文一致するレコードがあればidをセットする
  # 選択肢は#deep_embed_db_idで再帰でidをセットする
  def embed_record_id(tree)
    tree.each do |qa_node|
      next if qa_node[:id].blank?
      qa = @bot.question_answers.find_by(id: qa_node[:id])
      next if qa.blank?

      qa_node[:decision_branches_attributes].each do |db_node|
        db = qa.decision_branches.find_by(body: db_node[:body])
        next if db.blank?
        db_node[:id] = db.id
        db_node = deep_embed_db_id(db, db_node)
      end
    end
    tree
  end

  ##
  # embed_record_idで呼び出される
  # 選択肢のnodeを再帰でチェックしてbodyが一致するレコードがあればidをセットする
  def deep_embed_db_id(db, db_node)
    child_db_nodes = db_node[:child_decision_branches_attributes]
    return db_node if child_db_nodes.blank?

    child_db_nodes.each do |child_db_node|
      child_db = db.child_decision_branches.find_by(body: child_db_node[:body])
      next if child_db.blank?
      child_db_node[:id] = child_db.id
      child_db_node = deep_embed_db_id(child_db, child_db_node)
    end
    db_node
  end

  ##
  # 行からデータを抽出する
  def detect_or_initialize_by_row(row)
    id = sjis_safe(row[0]).to_i
    topic_tag_names = sjis_safe(row[1])&.gsub('／', '/')&.split("/")&.map(&:strip) || []
    q = sjis_safe(row[2])
    a = sjis_safe(row[3])

    # 選択肢と回答が入れ子になった状態で取得する
    decision_branch = row[4..-1].each_slice(2).map { |pair|
      # 選択肢のbodyがある場合のみデータを作る
      pair.first.present? ? { bot_id: @bot.id, body: sjis_safe(pair.first), answer: sjis_safe(pair.second) } : nil
    }.compact.reverse.reduce { |tail, parent|
      parent[:child_decision_branches_attributes] = [tail]
      parent
    }

    bot_had = @bot.question_answers.detect{ |qa| qa.id == id }.present?
    fail EmptyQuestionError.new if q.blank?
    fail EmptyAnswerError.new if a.blank?

    {
      key: bot_had ? id : "#{q}-#{a}",
      id: bot_had ? id : nil,
      topic_tag_names: topic_tag_names,
      question: q,
      answer: a,
      decision_branch: decision_branch,
    }
  end

  ##
  # 選択肢を再帰でチェックして同じ内容ならマージする
  def deep_merge_db(db_nodes)
    db_nodes.inject([]) { |res, db|
      same_db = res.detect{ |_db|
        _db[:body] == db[:body] && _db[:answer] == db[:answer] }
      if same_db.present?
        same_db[:child_decision_branches_attributes].concat(
          db[:child_decision_branches_attributes])
        db = same_db
      else
        res.push(db)
      end
      if db[:child_decision_branches_attributes].present?
        db[:child_decision_branches_attributes] = deep_merge_db(db[:child_decision_branches_attributes])
      end
      res
    }
  end

  private
    def sjis_safe(str)
      SjisSafeConverter.sjis_safe(str)
    end
end
