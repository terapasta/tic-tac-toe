@swtich_to_text_field = (obj) ->
  $(obj).hide()
  $(obj).next('.decision-branch-field').show().find('input').val($(obj).text()).focus()

@switch_to_label = (obj) ->
  $(obj).parents('.decision-branch-field').hide()
  $(obj).parents('.decision-branch-field').prev('.decision-branch-value').show().text($(obj).val())
  $(obj).parents('form').submit()

@enter_blur = (e) ->
  if e.which == 13
    e.target.blur()
    e.preventDefault()

$ ->
  $('#btn-auto-mode').on 'click', ->
    if $(this).hasClass('active')
      $('.auto-mode').val('0')
    else
      $('.auto-mode').val('1')

  # TODO tariningsのdecision_branches用(JS分離したい)
  $('.decision-branch-field').hide()

  # $('.decision-branch-value').on 'click', ->
  #   $(@).hide()
  #   $(@).next('.decision-branch-field').show().find('input').val($(@).text()).focus()

  # $('.decision-branch-field input').on 'blur', ->
  #   $(@).parents('.decision-branch-field').hide()
  #   $(@).parents('.decision-branch-field').prev('.decision-branch-value').show().text($(@).val())

  # $(f'.decision-branch-field input').keypress (e) ->
  #   if e.which == 13
  #     e.target.blur()
