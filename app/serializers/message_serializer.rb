class MessageSerializer < ActiveModel::Serializer
  include DeepCamelizeKeys

  attributes :id,
    :speaker,
    :rating,
    :created_at,
    :body,
    :icon_image_url,
    :answer_files,
    :answer_failed,
    :child_decision_branches,
    :decision_branches,
    :similar_question_answers,
    :is_show_similar_question_answers,
    :reply_log,
    :has_initial_questions

  has_one :question_answer

  def rating
    return 'nothing' if object.rating.blank?
    object.rating.level
  end

  def icon_image_url
    case object.speaker
    when 'guest'
      ActionController::Base.helpers.asset_path('silhouette.png')
    when 'bot'
      object.chat.bot.image_url(:thumb)
    end
  end

  def answer_files
    options = { only: [:file, :file_size, :file_type] }
    if object.question_answer.present?
      object.question_answer.answer_files.as_json(options)
    elsif object.decision_branch.present?
      object.decision_branch.answer_files.as_json(options).presence ||
      object.decision_branch.dest_question_answer&.answer_files.as_json(options) ||
      []
    end
  end

  def child_decision_branches
    (object.decision_branch&.child_decision_branches_or_answer_link || [])
      .map(&:as_json)
      .map{ |it| deep_camelize_keys(it) }
  end

  def decision_branches
    (object.question_answer&.decision_branches || [])
      .map(&:as_json)
      .map{ |it| deep_camelize_keys(it) }
  end

  def similar_question_answers
    (object.similar_question_answers || object.similar_question_answers_log || [])
      .map{ |it| it.respond_to?(:as_json) ? it.as_json : it }
      .map{ |it| deep_camelize_keys(it) }
  end

  def is_show_similar_question_answers
    return true if object.is_show_similar_question_answers.nil?
    !!object.is_show_similar_question_answers
  end
end
