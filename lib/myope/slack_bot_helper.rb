class SlackBotHelper
  module Color
    Success = '#36a64f'
    Warning = '#f1c856'
    Danger = '#eb4d5c'
  end

  def generate_attachments(results)
    results.select { |s|
      !s.result.accuracy.nan?
    }.map{ |x|
      {
        title: x.bot.name,
        text: (x.result.accuracy * 100).to_s + '%',
        color: score_color(x.result.accuracy),
      }
    }
  end

  def score_color(score)
    if score > 0.9
      Color::Success
    elsif score > 0.8
      Color::Warning
    else
      Color::Danger
    end
  end
end
