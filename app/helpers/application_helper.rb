module ApplicationHelper
  def space(length = 1)
    ('&nbsp;' * length).html_safe
  end
end
