module MessagesHelper
  def message_has_decision_branches?(msg)
    msg.question_answer&.decision_branches&.any? || msg.decision_branch&.child_decision_branches&.any?
  end

  def message_get_decision_branches_from(msg)
    msg.question_answer&.decision_branches || msg.decision_branch.child_decision_branches
  end

  def message_to_html(msg)
    options = {
      filter_html: true,
      space_after_headers: true,
    }

    extensions = {
      autolink: true,
      no_intra_emphasis: true,
    }
    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)
    rendered = markdown.render(msg).html_safe

    # imgタグ以外を削除
    sanitize(rendered, tags: %w(img))
  end
end