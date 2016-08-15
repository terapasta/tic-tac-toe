class DocomoClient
  def reply(bot, body)
    body = {
      utt: body,
      nickname: bot.name,
      age: 31,
      place: '東京',
      mode: 'dialog',
    }

    response = HTTP.post("https://api.apigw.smt.docomo.ne.jp/dialogue/v1/dialogue?APIKEY=#{ENV['DOCOMO_API_KEY']}", json: body)
    result = JSON.parse(response.body)

    return result['utt']
  end
end
