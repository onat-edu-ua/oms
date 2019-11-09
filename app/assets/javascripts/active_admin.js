//= require active_admin/base
//= require active_admin_sidebar
//= require chosen-jquery
//= require includes/apply_chosen
//= require includes/fill_password
//= require includes/active_admin_modal_link

$(document).ready(function () {
  $('.modal-link').on('modal_link:open:set_role', function (e, form) {
    var $form = $(form);
    $form.find('select').chosen({ width: '100%', disable_search: true });
  });
});
