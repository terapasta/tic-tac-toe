class TopsController < ApplicationController
  def show
    @answer_ids = [9]
    @texts = []
  end

  def create
    # HACK リファクタリング
    @answer_ids = params[:answer_ids]
    @texts = params[:texts] || []

    answer_ids = @answer_ids
    while answer_ids.count < 2
      answer_ids.unshift(0)
      @texts.unshift('')
    end
    @texts << params[:text]

    #binding.pry
    text = Shellwords.escape(params[:text])
    Rails.logger.debug(text)

    cmd = "cd learning; python main_predict.py #{answer_ids[-2..-1].join(' ')} #{params[:text]}"
    Rails.logger.debug(cmd)
    output = `#{cmd}`
    Rails.logger.debug("output: #{output}")

    answer_id = output.split("\n").last
    @answer_ids << answer_id


    # if !$?.success?
    #   @result = "診断に失敗しました"
    # elsif is_getwild == 0
    #   @result = "「#{training_set.text}」はGetWildではありません。"
    # elsif is_getwild == 1
    #   @result = "「#{training_set.text}」はGetWildです。"
    # end

    render :show
  end
end
