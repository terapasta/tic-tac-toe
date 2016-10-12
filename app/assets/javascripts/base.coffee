$ ->
  # FIXME trainings.coffeeに記述したいが、answers_controllerを経由した際に読み込まれないため一旦baseに記述する
  $('.message-body-wrapper').on 'click', ->
    $(@).hide()
    $(@).next('.message-body-edit').removeClass('hidden').find('input').val(body).focus()
