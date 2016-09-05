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
    $(@).next('.decision-branch-field').show().val($(@).text()).focus()

  # $('.decision-branch-field').on 'blur', ->
  #   alert('hoge')
  #   $(@).hide()
  #   $(@).prev('.decision-branch-value').show()
  #
  # $('.decision-branch-field').keypress (e) ->
  #   if e.which == 13
  #     e.target.blur()
