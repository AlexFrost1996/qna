$(document).on('turbolinks:load', function(){
  $('.votes').on('ajax:success', function(e) {
    var vote = e.detail[0];
    $(`.${vote.model}-id-${vote.votable_id} .votes .rating`).html(`${vote.rating}`)

    if (vote.user_vote == 'like'){
      $(`.${vote.model}-id-${vote.votable_id} .votes .dislike i`).removeClass('fa-thumbs-down')
      $(`.${vote.model}-id-${vote.votable_id} .votes .dislike i`).addClass('fa-thumbs-o-down')

      $(`.${vote.model}-id-${vote.votable_id} .votes .like i`).removeClass('fa-thumbs-o-up')
      $(`.${vote.model}-id-${vote.votable_id} .votes .like i`).addClass('fa-thumbs-up')
    } 
    else if (vote.user_vote == 'dislike'){
      $(`.${vote.model}-id-${vote.votable_id} .votes .like i`).removeClass('fa-thumbs-up')
      $(`.${vote.model}-id-${vote.votable_id} .votes .like i`).addClass('fa-thumbs-o-up')

      $(`.${vote.model}-id-${vote.votable_id} .votes .dislike i`).removeClass('fa-thumbs-o-down')
      $(`.${vote.model}-id-${vote.votable_id} .votes .dislike i`).addClass('fa-thumbs-down')
    }
    else {
      $(`.${vote.model}-id-${vote.votable_id} .votes .dislike i`).removeClass('fa-thumbs-down')
      $(`.${vote.model}-id-${vote.votable_id} .votes .dislike i`).addClass('fa-thumbs-o-down')

      $(`.${vote.model}-id-${vote.votable_id} .votes .like i`).removeClass('fa-thumbs-up')
      $(`.${vote.model}-id-${vote.votable_id} .votes .like i`).addClass('fa-thumbs-o-up')
    }
  })
    .on('ajax:error', function(e) {
      var errors = e.detail[0];

      $.each(errors, function(index, value) {
        $('p.notice').append(`<div class="flash-alert">${value}</div>`)
      })
    })
});
