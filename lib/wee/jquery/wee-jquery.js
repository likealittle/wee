wee = {}
wee._update_elements = function(_,e) {
  var src = jQuery(e);
  var id = src.attr('id'); 
  if (id) {
    jQuery('#'+id).replaceWith(src);
  }
};

wee._update_callback = function(data) {
  jQuery(data).each(wee._update_elements); 
};

wee.update = function(url) {
  jQuery.get(url, {}, wee._update_callback, 'html');
  return false;
};

wee.get_form_values = function () {
    res = {}
    $(this.form).find(":input").not(":submit").each(function(idx, elem) {
        res[$(elem).attr("name")] = $(elem).val();
    });

    return res;
}

wee._update_post_callback = function (data) {
    wee._update_callback(data);
    if (wee.focused_element != null) {
        $(wee.focused_element).focus();
        wee.focused_element = null;
    }
}

wee.post_callback = function(url) {
    wee.focused_element = document.activeElement;
    var action = $("form").attr("action");
    if (console.log) {
        console.log(action);
    }
    jQuery.post(action, wee.get_form_values(), wee._update_post_callback, 'html')
    return false;
}
