//= require jquery
//= require jquery_ujs
//= require jquery_nested_form
//= require tether
//= require bootstrap-v4.0.0-alpha.6-js/tooltip
//= require_tree ../../../vendor/assets/javascripts/bootstrap-v4.0.0-alpha.6-js
//= require bundled-es2015
//= require app/threads

window.jQuery(function($) {
  $('select[data-role="url-switcher"]').on('change', function() {
    var $select = $(this);
    var url = $select.val();
    if (url != null && url.length > 0) {
      window.location.href = url;
    }
  });
});
