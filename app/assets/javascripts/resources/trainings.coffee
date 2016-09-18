@swtich_to_text_field = (obj) ->
  $decision_branch_value = $(obj).parents('.decision-branch-value')
  $decision_branch_value.hide()
  body = $decision_branch_value.text()
  $decision_branch_value.next('.decision-branch-field').show().find('input').val(body).focus()

@switch_to_label = (obj) ->
  $(obj).parents('.decision-branch-field').hide()
  $(obj).parents('.decision-branch-field').prev('.decision-branch-value').show()
    .children('.body').text($(obj).val())
  $(obj).parents('form').submit()

@enter_blur = (e) ->
  if e.which == 13
    e.target.blur()
    e.preventDefault()

@destroy_decision_branch_field = (obj) ->
  $(obj).parents('li').remove()

@disable_answer_bodies = ->
  $('.balloon').each (idx, elem) ->
    answer_body = $(elem).find('#answer_body').val()
    unless answer_body == undefined
      $(elem).html(answer_body)

$ ->
  $('#btn-auto-mode').on 'click', ->
    if $(this).hasClass('active')
      $('.auto-mode').val('0')
    else
      $('.auto-mode').val('1')

  $('.decision-branch-field').hide()
