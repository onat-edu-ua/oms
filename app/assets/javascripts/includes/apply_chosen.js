$(document).ready(function () {

  $('.chosen').chosen({});

  $('.chosen-with-opts').each(function(){
    var $el = $(this);
    var chosenOpts = $el.data('chosen-opts');
    $el.chosen(chosenOpts);
  });

  $('#filters_sidebar_section > .panel_contents > .filter_form > .select_and_search > select').chosen({
    disable_search: true
  });

});
