wee = {};
wee._update_elements = function(_,e) {
    var src = jQuery(e);
    var id = src.attr('id'); 

    if (id) {
        var currentNode = $("#" + id);
        var focused = currentNode.find(":text").filter(":focus");
        console.log("there are " + focused.size() + " elements");
        currentNode.replaceWith(src);
        if (focused.size() > 0) {
            src.find("#" + id).replaceWith(focused);
            focused.focus();
        }
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

wee.post_callback = function(only_notify, async) {
    wee.focused_element = document.activeElement.id
    url = $("form").attr("action");

    $("form").attr("disabled", "disabled");

    var callback;
    if (only_notify) {
        callback = function() {};
    } else {
        callback = wee._update_post_callback;
    }
    jQuery.ajax({
        type: 'POST',
        async: async,
        url: url,
        data: wee.get_form_values(),
        success: function (data) {
            if (!only_notify) {
                wee._update_callback(data);
            }
        },
        dataType: 'html'});
    return false;
}
