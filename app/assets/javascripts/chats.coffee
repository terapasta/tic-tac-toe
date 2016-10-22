@disable_question_field = ->
  $('#message_body').attr('disabled', true)
  $('.question').attr('disabled', true)

@enable_question_field = ->
  $('#message_body').attr('disabled', false)
  $('.question').attr('disabled', false)
