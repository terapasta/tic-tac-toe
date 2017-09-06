//= require jquery
//= require jquery_ujs
//= require jquery_nested_form
//= require tether
//= require bootstrap-v4.0.0-alpha.6-js/tooltip
//= require_tree ../../../vendor/assets/javascripts/bootstrap-v4.0.0-alpha.6-js
//= require bundled-es2015
//= require app/threads
//= require app/selection-checkboxes

window.jQuery(function($) {
  $('[data-toggle="tooltip"]').tooltip();

  $('select[data-role="url-switcher"]').on('change', function() {
    var $select = $(this);
    var url = $select.val();
    if (url != null && url.length > 0) {
      window.location.href = url;
    }
  });

  $('[data-role="message-mark-button"]').on('click', function(e) {
    e.preventDefault();
    var $button = $(this);
    var id = $button.data('id');
    var url = '/api/bots/' + window.currentBot.id + '/messages/' + id + '/mark';
    var method = $button.hasClass('active') ? 'DELETE' : 'POST';

    $.ajax(url, {
      method: method,
      dataType: 'json',
    }).done(function() {
      $button.toggleClass('active');
    });
  });
});
