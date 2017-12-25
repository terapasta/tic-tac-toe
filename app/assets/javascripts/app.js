//= require jquery
//= require jquery_ujs
//= require jquery_nested_form
//= require popper
//= require bootstrap-sprockets
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

  $('[data-role="collapsible').on('dblclick', function(e) {
    e.preventDefault()
    $(e.currentTarget).toggleClass('active')
  })

  $('[data-toggle="popover"]').popover()
});
