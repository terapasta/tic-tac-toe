class QuestionAnswerDecorator < Draper::Decorator
  delegate_all

  def as_tree_node_json
    {
      id: object.id,
      answer: object.answer.decorate.as_tree_node_json
    }
  end
end
