window.jQuery$(function($) {
  var $filterNav = $('[data-role="threads-filter-nav"]');
  var $checkboxes = $filterNav.find('input[type="checkbox"]')
  var state = {
    answer_failed: false,
    good: false,
    bad: false,
    marked: false,
  };

  // Set initial state
  $checkboxes.each(function() {
    var $checkbox = $(this);
    state[$checkbox.attr('name')] = $checkbox.prop('checked');
  });

  // Listen checkbox's onchange event
  $checkboxes.on('change', function() {
    var $checkbox = $(this);
    state[$checkbox.attr('name')] = $checkbox.prop('checked');
    // Jump to next state
    $checkboxes.each(function() { $(this).attr({ disabled: true }); });
    jumpTo(state);
  });

  var jumpTo = function(state) {
    var newState = $.extend(getQueryParams(), state);
    window.location.search = toQueryString(newState);
  };

  // Convert object to query string
  var toQueryString = function(obj) {
    return Object.keys(obj).map(function(key) {
      return [key, obj[key]].join('=');
    }).join('&');
  };

  var getQueryParams = function() {
    var result = {};
    window.location.search.replace('?', '').split('&').forEach(function(pair) {
      var splitted = pair.split('=')
      result[splitted[0]] = splitted[1];
    });
    return result;
  };
});
