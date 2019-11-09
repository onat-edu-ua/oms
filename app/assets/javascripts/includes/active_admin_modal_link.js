var ActiveAdminModalLink = (function (){
  function ActiveAdminModalLink (node, options) {
    options = options || {};
    this.initialize(node, options);
  }

  ActiveAdminModalLink.prototype = (function (){
    var _node = null;
    var _options = null;
    return {
      constructor: ActiveAdminModalLink,
      initialize: function (node, options) {
        _node = node;
        _options = options;
        this.addHandler();
      },
      addHandler: function () {
        var that = this;
        $(_node).on('click', function (e) {
          e.stopPropagation();
          e.preventDefault();
          that.openModalWindow();
        });
      },
      openModalWindow: function () {
        var authenticityToken = $('head meta[name="csrf-token"]')[0].content;
        var that = this;
        var $node = $(_node);
        var confirmData = $node.data('confirm') || '';
        var inputsData = $node.data('inputs') || {};
        var url = $node.data('url');
        var method = $node.data('method');
        var extra = $node.data('extra');
        var formName = $node.data('formName');
        var defaultParams = $node.data('defaultValues');

        ActiveAdmin.modal_dialog(
          confirmData,
          inputsData,
          function (inputs) {
            var params = { _method: method, authenticity_token: authenticityToken };
            $.extend(true, inputs, extra);
            $.each(inputs, function (key, value) {
              var full_key = formName + '[' + key + ']';
              params[full_key] = value;
            });
            if (_options.beforePost) _options.beforePost($node, params);
            that.triggerEvents('beforePost', [params]);
            ActiveAdminModalLink.postForm(url, params);
          }
        );

        var $form = $('body > div:nth-last-child(2)').find('form');
        $form.addClass('modal-link-form');
        $form.data('form-name', formName);

        if (defaultParams) {
          $.each(defaultParams, function (key, value) {
            $form.find('select[name="' + key + '"], input[name="' + key + '"]').val(value)
          });
        }

        if (_options.afterOpen) _options.afterOpen($node, $form, $node.data());
        that.triggerEvents('afterOpen', [$form[0], $node.data()]);
      },
      triggerEvents: function (eventName, eventData) {
        var $node = $(_node);
        var formName = $node.data('form-name');
        $node.trigger('modal_link:open', [formName] + eventData);
        $node.trigger('modal_link:open:' + formName, eventData);
      }
    }
  })();

  ActiveAdminModalLink.postForm = function (url, params, method) {
    method = method || "post"; // Set method to post by default, if not specified.

    var addInputToForm = function (name, value, form) {

      if (Array.isArray(value)) {
        value.forEach(function (val) {
          addInputToForm(key + '[]', val, form);
        });
        return;
      }
      var hiddenField = document.createElement("input");
      hiddenField.setAttribute("type", "hidden");
      hiddenField.setAttribute("name", name);
      hiddenField.setAttribute("value", value);

      form.appendChild(hiddenField);
    };

    // The rest of this code assumes you are not using a library.
    // It can be made less wordy if you use one.
    var form = document.createElement("form");
    form.setAttribute("method", method);
    form.setAttribute("action", url);

    for (var key in params) {
      if (params.hasOwnProperty(key)) {
        var value = params[key];
        addInputToForm(key, value, form);
      }
    }

    document.body.appendChild(form);
    form.submit();
  }

  return ActiveAdminModalLink;
})();

$.fn.activeAdminModalLink = function (options) {
  if (this.length === 1 && this.data('activeAdminModalLink')) {
    return this.data('activeAdminModalLink');
  }
  this.each(function () {
    var $node = $(this);
    if ($node.data('activeAdminModalLink')) return;
    var data = new ActiveAdminModalLink($node[0], options);
    $node.data('activeAdminModalLink', data);
  });
}

$(document).ready(function () {
  $('.modal-link').activeAdminModalLink();
});
