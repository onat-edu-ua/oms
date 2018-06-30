$(document).ready(function () {
  var PASSWORD_CHARSET = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

  var generatePassword = function (length) {
    var retVal = "";
    for (var i = 0, n = PASSWORD_CHARSET.length; i < length; ++i) {
      retVal += PASSWORD_CHARSET.charAt(Math.floor(Math.random() * n));
    }
    return retVal;
  }

  $('.js-fill-password').dblclick(function () {
    var $input = $(this);
    var length = parseInt($input.data('password-length') || '8');
    $input.val(generatePassword(length));
  });

});
