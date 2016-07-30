json.guest_key @chat.guest_key
json.messages @reply_messages do |message|
  json.body message.body
end
