function updateCell(url, span, offset) {
    var data = {"jcrMethodToCall":"put"};
    if (span != null) {
        data["span"] = span;
    }
    if (offset != null) {
        data["offset"] = offset;
    }
    $.post(url, data, function(result) {
        window.location.reload();
    }, "json");
}
