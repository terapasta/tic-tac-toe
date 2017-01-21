$ ->
  $('#answer_body').on 'railsAutocomplete.select', (event, data) ->
    $('#static-answer-body').html(data.item.label)
    $('#question_answer_answer_id').val(data.item.id)
    $(@).val('')
