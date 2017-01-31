@disable_question_field = ->
  $('#message_body').attr({ disabled: true })
  $('#chat-submit').attr({ disabled: true })

@enable_question_field = ->
  $('#message_body').attr({ disabled: false })
  $('#chat-submit').attr({ disabled: false })

$ ->
  $(document).on 'ajax:complete', '[data-role="chat-decision-branch"]', (e, xhr, status) =>
    $decisionBranch = $(e.target)
    if status is "success"
      $decisionBranch.parents('[data-role="chat-decision-branches"]').hide()
