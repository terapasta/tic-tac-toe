@swtich_to_text_field = (obj) ->
  $decision_branch_value = $(obj).parents('.decision-branch-value')
  $decision_branch_value.hide()
  body = $decision_branch_value.text()
  $decision_branch_value.next('.decision-branch-field').show().find('input').val(body).focus()

@switch_to_label = (obj) ->
  # $(obj).parents('form').children('.decision-branch-field')
  $(obj).parents('.decision-branch-field').hide()
  # $(obj).parents('form').children('.decision-branch-field').children('.body').text($(obj).val())
  $(obj).parents('form').children('.decision-branch-value').children('a').text($(obj).val())
  $(obj).parents('.decision-branch-field').prev('.decision-branch-value').show()
  $(obj).parents('form').submit()

@enter_blur = (e) ->
  if e.which == 13
    e.target.blur()
    e.preventDefault()

@destroy_decision_branch_field = (e) ->
  e.preventDefault()
  $(e.srcElement).parents('li').remove()

@disable_answer_bodies = ->
  $('.balloon').each (idx, elem) ->
    answer_body = $(elem).find('#answer_body').val()
    unless answer_body == undefined
      $(elem).html(answer_body)

# @click_decision_branch = (obj) ->
#   $li = $(obj).parents('li')
#   $('.list-group-item').removeClass('active')
#   decision_branch_id = $li.data('decision-branch-id')
#   return unless decision_branch_id
#   $li.addClass('active')
#   $li.children('form').find('#decision_branch_id').val(decision_branch_id)
#   $li.children('form').first().submit()

$ ->
  $('#btn-auto-mode').on 'click', ->
    if $(this).hasClass('active')
      $('.auto-mode').val('0')
    else
      $('.auto-mode').val('1')

  $('.decision-branch-field').hide()

  $('.message-body-wrapper').on 'click', ->
    $(@).hide()
    $textarea = $(@).next('.message-body-edit').removeClass('hidden').find('textarea[data-autocomplete]')
    $textarea.focus()
    # $textarea.val(body).focus()

  $('textarea[data-autocomplete]').railsAutocomplete()
  $('textarea[data-autocomplete]').on 'railsAutocomplete.select', (e, data) ->
    $headline = $(@).parents('.message-body-edit').find('#training_message_answer_attributes_headline')
    $headline.val(data.item.headline)
  $('textarea[data-autocomplete]').on 'focus', (e) ->
    $(@).select()

  $('textarea[data-autocomplete]').on 'keydown', (e) ->
    keyCode = $.ui.keyCode
    if e.keyCode == keyCode.DOWN || e.keyCode == keyCode.UP
      e.stopImmediatePropagation()

  window.location.hash = '#last-message'
