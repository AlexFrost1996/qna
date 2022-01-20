$(document).on('turbolinks:load', function(){
  $('.question-container').on('click', '.edit-question-link', function(e) {
    e.preventDefault();
    $(this).hide();
    var questionId = $(this).data('questionId');
    $('form#edit-question-' + questionId).removeClass('hidden')
  })

  $('.votes').on('ajax:error', function(e) {
    var errors = e.detail[0];

    $.each(errors, function(index, value) {
      $('.question-errors').append(`<p>${value}</p>`)
    })

  })
});
