class Conversation
  def self.reply(message)
    client = MessagePack::RPC::Client.new('127.0.0.1', 6000)
    context = [0, 9]
    result = client.call(:reply, context, message.body)
    Rails.logger.debug("result: #{result}")

    # # @answer_ids = params[:answer_ids]
    # # @texts = params[:texts] || []
    # #
    # # answer_ids = @answer_ids.dup
    # # while answer_ids.count < 2
    # #   answer_ids.unshift(0)
    # #   #@texts.unshift('')
    # # end
    # # @texts << params[:text]
    # #
    # # #binding.pry
    # body = Shellwords.escape(message.body)
    # #
    # # 後ろから二番目が回答済みのanswerの場合
    # # if Answer.find(answer_ids.last(2).first).answerd
    # #   feature_answer_ids = [0, 9]
    # # else
    # #   feature_answer_ids = answer_ids[-2..-1]
    # # end
    #
    # feature_answer_ids = [0, 9]  # 文脈は一旦固定で入れる
    # cmd = "cd learning; python main_predict.py #{feature_answer_ids.join(' ')} #{body}"
    # Rails.logger.debug(cmd)
    # output = `#{cmd}`
    # Rails.logger.debug("output: #{output}")
    # answer_id = output.split("\n").last
    #
    # Answer.find(answer_id)
  end
  #
  # answer_id = output.split("\n").last
  # @answer_ids << answer_id
  #
  # # 回答済みの場合は、予測に流すパラメータをクリアにする
  # answer = Answer.find(answer_id)
  # if answer.answerd
  #   @answer_ids << 9  # 何について知りたい？〜のanswer_id
  #   @texts << 'MAGIC_WORD'  # Viewを調整するための特殊な文言
  # end
  #
  # render :show
end
