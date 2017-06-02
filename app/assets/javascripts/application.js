// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery_nested_form
//= require autocomplete-rails
//= require bootstrap-sprockets
//= require bootstrap-tagsinput
//= require toastr
//= require base
//= require bundled-es2015

$(function() {
  var $notificationModal = $('[data-role="notification-modal"]');
  $notificationModal.find('.close').on('click', function() {
    $notificationModal.removeAttr("style").hide();
    $('.modal-backdrop').hide();
  });

  var selectionCheckBoxies = $('[data-role="select-question-answer"]');
  selectionCheckBoxies.on('change', function() {
    var $checkbox = $(this);
    $url = "/bots/" + $checkbox.data('bot-id') + '/question_answers/' + $checkbox.data('question-answer-id') + '/selections' + '.json'
    if($checkbox.is(':checked')) {
      var $type = 'POST'
    }
    else {
      var $type = 'DELETE'
    };
    $.ajax({
      type: $type,
      url: $url,
      datatype: 'json',
    })
  })
});
