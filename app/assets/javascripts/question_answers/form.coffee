$ ->
  $('#answer_body').on 'railsAutocomplete.select', (event, data) ->
    $('#answer_text_area').html(data.item.label)
    $('#question_answer_answer_id').val(data.item.id)
    $(@).val('')
