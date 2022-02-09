$(document).on('turbolinks:load', function(){
  $('.new-comment')
    .on('ajax:error', function(e) {
      var errors = e.detail[0];

      $.each(errors, function(index, value) {
        $('div.notice').append(`<div class="flash-error flash-alert">${value}</div>`)
      })
    })
});
