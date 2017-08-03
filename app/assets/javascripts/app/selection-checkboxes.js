window.jQuery(function($) {
  var selectionCheckBoxies = $('[data-role="select-question-answer"]');
  selectionCheckBoxies.on('change', function() {
    var $checkbox = $(this);
    var $counter = $('[data-role="select-question-answer-counter"]');
    var isChecked = $checkbox.is(':checked');
    var currentCount = window.parseInt($counter.text());
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

        if (window.mixpanel == null) { return; }
        var options = {
          bot_id: (window.currentBot || {}).id,
          bot_name: (window.currentBot || {}).name,
        };
        if (isChecked) {
          window.mixpanel.track("Select question answer for initial list", options);
        } else {
          window.mixpanel.track("Reject question answer for initial list", options);
        }
      });
  });
});
