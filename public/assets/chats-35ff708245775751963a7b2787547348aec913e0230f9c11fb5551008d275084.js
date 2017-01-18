(function() {
  this.disable_question_field = function() {
    $('#message_body').attr('disabled', true);
    return $('.question').attr('disabled', true);
  };

  this.enable_question_field = function() {
    $('#message_body').attr('disabled', false);
    return $('.question').attr('disabled', false);
  };

}).call(this);
