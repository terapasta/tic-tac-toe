module ApplicationHelper
  def space(length = 1)
    ('&nbsp;' * length).html_safe
  end

  def need_side_nav?
    !chat_page? && policy(:static_pages).can_use_nav?(@bot)
  end
end
