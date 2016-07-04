#require 'msgpack/rpc'
class ChatsController < ApplicationController
  before_action :set_chat

  def show
  end

  def create
    guest_message = @chat.messages.build(message_params)
    guest_message.speaker = 'guest'

    answer = Conversation.new(guest_message).reply

    @chat.messages.build(speaker: 'bot', body: answer.body)
    @chat.save

    redirect_to chats_path

    # HACK リファクタリング
    # @answer_ids = params[:answer_ids]
    # @texts = params[:texts] || []
    #
    # answer_ids = @answer_ids.dup
    # while answer_ids.count < 2
    #   answer_ids.unshift(0)
    #   #@texts.unshift('')
    # end
    # @texts << params[:text]
    #
    # #binding.pry
    # text = Shellwords.escape(params[:text])
    # Rails.logger.debug(text)
    #
    # # 後ろから二番目が回答済みのanswerの場合
    # if Answer.find(answer_ids.last(2).first).answerd
    #   feature_answer_ids = [0, 9]
    # else
    #   feature_answer_ids = answer_ids[-2..-1]
    # end
    #
    # cmd = "cd learning; python main_predict.py #{feature_answer_ids.join(' ')} #{params[:text]}"
    # Rails.logger.debug(cmd)
    # output = `#{cmd}`
    # Rails.logger.debug("output: #{output}")
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

  def destroy
    Chat.last.messages.destroy_all
    redirect_to chats_path
  end

  private
    def set_chat
      @chat = Chat.last || Chat.create(thread_key: 'DUMMY')
    end

    def message_params
      params.require(:message).permit(:body)
    end
end
