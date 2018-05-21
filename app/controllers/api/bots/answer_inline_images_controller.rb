class Api::Bots::AnswerInlineImagesController < Api::BaseController
  include BotUsable

  def create
    bot = bots.find(params[:bot_id])
    answer_inline_image = bot.answer_inline_images.build(permitted_attributes(AnswerInlineImage))
    if answer_inline_image.save
      render json: answer_inline_image, adapter: :json, status: :created
    else
      render_unprocessable_entity_error_json(answer_inline_image)
    end
  end
end
