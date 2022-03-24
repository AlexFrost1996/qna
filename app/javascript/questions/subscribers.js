$(document).on('turbolinks:load', function() {

  $('.question-subscribtion').on('ajax:success', function(e) {
    let html = e.detail[0];
    $('.question-subscribtion').html(html.body.innerHTML);
  })

});
