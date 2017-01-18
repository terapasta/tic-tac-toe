(function() {
  $(function() {
    $('#width').on('change', function() {
      var embed_val, width;
      width = $(this).val();
      embed_val = $('#embed').val();
      embed_val = embed_val.replace(/width=\"[^\"]*\"/, "width=\"" + width + "\"");
      return $('#embed').val(embed_val);
    });
    return $('#height').on('change', function() {
      var embed_val, height;
      height = $(this).val();
      embed_val = $('#embed').val();
      embed_val = embed_val.replace(/height=\"[^\"]*\"/, "height=\"" + height + "\"");
      return $('#embed').val(embed_val);
    });
  });

}).call(this);
