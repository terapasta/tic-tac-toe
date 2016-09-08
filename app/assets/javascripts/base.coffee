$ ->
  $('#btn-auto-mode').on 'click', ->
    if $(this).hasClass('active')
      $('.auto-mode').val('0')
    else
      $('.auto-mode').val('1')

  # TODO tariningsのdecision_branches用(JS分離したい)
  $('.decision-branch-field').hide()
  $('.decision-branch-value').on 'click', ->
    $(@).hide()
    $(@).next('.decision-branch-field').show().find('input').val($(@).text()).focus()

  $('.decision-branch-field input').on 'blur', ->
    $(@).parents('.decision-branch-field').hide()
    $(@).parents('.decision-branch-field').prev('.decision-branch-value').show().text($(@).val())

  $('.decision-branch-field input').keypress (e) ->
    if e.which == 13
      e.target.blur()
