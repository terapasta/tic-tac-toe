class DocomoClient
  def reply(chat, bot, body)
    body = {
      utt: body,
      mode: 'dialog',
      context: chat.guest_key,
    }
    Rails.logger.debug("DocomoClient request body: #{body}")

    response = HTTP.post("https://api.apigw.smt.docomo.ne.jp/dialogue/v1/dialogue?APIKEY=#{ENV['DOCOMO_API_KEY']}", json: body)
    result = JSON.parse(response.body)

    Rails.logger.debug("DocomoClient response body: #{result}")

    return result['utt']
  end
end
