class SlackBotHelper
  module Color
    Success = '#36a64f'
    Warning = '#f1c856'
    Danger = '#eb4d5c'
  end

  def bot_scores_as_attachment
    Score.includes(:bot).all.map{ |score|
      {
        title: score.bot.name,
        text: (score.accuracy * 100).to_s + '%',
        color: score_color(score.accuracy),
      }
    }.to_json
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

  def send_bot_scores(prefix = '')
    Slappy::Messenger.new({
      text: prefix + '各ボットの正答率',
      channel: '#random',
      attachments: bot_scores_as_attachment,
    }).message
  end
end
