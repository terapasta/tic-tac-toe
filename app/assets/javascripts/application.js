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
    var $counter = $('[data-role="select-question-answer-counter"]');
    var isChecked = $checkbox.is(':checked');
    var currentCount = parseInt($counter.text());
    if (currentCount === 5 && isChecked) {
      $checkbox.attr({ checked: false });
      return window.alert("選択できるQ&Aは" + currentCount + "個までです");
    }
    var botId = $checkbox.data('bot-id');
    var questionAnswerId = $checkbox.data('question-answer-id');
    var url = '/bots/' + botId + '/question_answers/' + questionAnswerId + '/selections.json';
    var type = isChecked ? 'POST' : 'DELETE';

    $checkbox.attr({ disabled: true });
    $.ajax({ type: type, url: url, datatype: 'json' })
      .done(function() {
        var $label = $('[data-role="select-question-answer-label"][data-question-answer-id="' + questionAnswerId + '"]');
        $label.text(isChecked ? '選択済' : '未選択')
              .attr({ class: "label label-" + (isChecked ? "success" : "default") });

        var nextCount = currentCount + (isChecked ? 1 : -1);
        $counter.text(nextCount);
      })
      .always(function() {
        $checkbox.attr({ disabled: false });
      });
  });

  $('select[data-role="url-switcher"]').on('change', function() {
    var $select = $(this);
    var url = $select.val();
    if (url != null && url.length > 0) {
      location.href = url;
    }
  });
});
