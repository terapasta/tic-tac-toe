@disable_question_field = ->
  $('#message_body').attr({ disabled: true })
  $('#chat-submit').attr({ disabled: true })

@enable_question_field = ->
  $('#message_body').attr({ disabled: false })
  $('#chat-submit').attr({ disabled: false })
