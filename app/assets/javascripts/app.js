//= require jquery
//= require jquery_ujs
//= require jquery_nested_form
//= require popper
//= require bootstrap-sprockets
//= require app/threads
//= require app/selection-checkboxes

window.jQuery(function($) {
  $('[data-toggle="popover"]').popover();
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

  var modal = document.querySelector('#questionAnswerModal .modal-dialog')
  var cards = document.querySelectorAll('.modal-qa-showed')
  Array.prototype.forEach.call(cards, function (card) {
    card.addEventListener('click', function () {
      var questionAnswerId = card.getAttribute('value')
      var url = '/bots/' + window.currentBot.id + '/question_answers/' + questionAnswerId + '?qacard=true';
      $.get(url).done(function(html) {
        modal.innerHTML = html
      })
    })
  })
})
