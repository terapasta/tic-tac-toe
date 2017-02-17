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

  $newMessageForm = $('#new_message')
  $newMessageForm.on 'ajax:beforeSend', (e, xhr, settings) =>
    $form = $(e.target)
    data = $form.serializeArray()
    body = $.grep(data, (item, i) => item.name is 'message[body]')[0]
    if body.value is ""
      xhr.abort()
      toastr.warning 'メッセージを入力してください'

  $newMessageForm.on 'ajax:error', (e, xhr, status, error) =>
    toastr.error '質問を送信できませんでした。ご迷惑おかけして申し訳ありません。', 'エラー'
