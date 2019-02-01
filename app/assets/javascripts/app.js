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

  // Safari で Syntax エラーとなるので合わせて修正 pivotal -> #163214830
  $('[data-role="collapsible"]').on('dblclick', function(e) {
    e.preventDefault()
    $(e.currentTarget).toggleClass('active')
  })

  var modal = document.querySelector('#questionAnswerModal .modal-dialog .modal-content')
  var cards = document.querySelectorAll('.modal-qa-showed')
  Array.prototype.forEach.call(cards, function (card) {
    card.addEventListener('click', function () {
      var questionAnswerId = card.getAttribute('value')
      var url = '/bots/' + window.currentBot.id + '/question_answers/' + questionAnswerId + '?qacard=true&is_modal=true';
      $.get(url).done(function(html) {
        modal.innerHTML = html
      })
    })
  })

  // 一回のサブミットで10MB以上添付すると nginx 413 に振られるのを防ぐ pivotal -> #163214830
  $(function() {
    $('#answer-files').on('change', 'input', function() {
      var fileSizeSum = 0;
      $.each($('.file-size-check'), function(i, value) {
        // キャンセル済みファイルはカウントしない(キャンセルすると親の親ノードが display: none になる)
        if ($(value).parent().parent().css('display') == 'none') {
          return true;
        }
        // undefined のサイズを掴まないようチェック
        if (value.files[0]) fileSizeSum += value.files[0].size
      })
      if (fileSizeSum > 10*1024*1024) {
        $(this).parent().parent().append('<div class="alert alert-danger mt-2 file-alert"></div>');
        $(".file-alert").html('合計ファイルサイズが10MB以上のため添付できません')
        setTimeout(function() {
          $(".file-alert").hide(400)
        }, 3000);
        $(this).replaceWith($(this).val('').clone(true));
      }
    })
  })
}) 
