$ ->
  $('#width').on 'change', ->
    width = $(@).val()
    embed_val = $('#embed').val()
    embed_val = embed_val.replace(/width=\"[^\"]*\"/, "width=\"#{width}\"")
    $('#embed').val(embed_val)

  $('#height').on 'change', ->
    height = $(@).val()
    embed_val = $('#embed').val()
    embed_val = embed_val.replace(/height=\"[^\"]*\"/, "height=\"#{height}\"")
    $('#embed').val(embed_val)
