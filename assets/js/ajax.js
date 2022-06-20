import $ from 'jquery'
window.jQuery = $
window.$ = $

function makeRemote() {
    let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");

    $("a[data-remote='true']").click(function(event) {
        event.preventDefault();

        $.ajax({
            method: $(this).data('method'),
            url: $(this).attr("href"),
            dataType: "script",
            beforeSend: function(request) {
                request.setRequestHeader("x-csrf-token", csrfToken);
            },
            complete: function(_jqXHR,_textStatus) {
                // remove a loader or whatever
            }
        });
    });

    $("form[data-remote='true']").submit(function(event) {
        event.preventDefault();
        let $form = $(this);

        $.ajax({
            method: $form.attr("method"),
            url: $form.attr("action"),
            data: $form.serialize(),
            dataType: "script",
            beforeSend: function(request) {
                request.setRequestHeader("x-csrf-token", csrfToken);
            },
            complete: function(_jqXHR,_textStatus) {
                // remove a loader or whatever
            }
        });
    });
}

export default makeRemote;
