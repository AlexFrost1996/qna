$(document).on('turbolinks:load', function() {

  $('.search-container').on('ajax:success', function(e) {
    let html = e.detail[0];
    $('.search-result').html("");
    $('.search-result').html(html.body.innerHTML);
  })
});
