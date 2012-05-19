// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function() {
  // Enable alert dismissal
  $('.alert').alert();

  // Enable ratings buttons
  $('.like').click(function(e) {
    e.preventDefault();
    var el = $(this);
    var post = el.closest('.post');
    // Disable buttons
    var buttons = post.find('.vote a');
    buttons.addClass('disabled');
    buttons.off('click');
    // Submit vote
    var post_id = post.attr('data-target');
    $.post('/posts/upvote', {'post_id': post_id}, function(data) {
      // Update count
      el.children('.count').html(data);
    });
  });
  $('.dislike').click(function(e) {
    e.preventDefault();
    var el = $(this);
    var post = el.closest('.post');
    // Disable buttons
    var buttons = post.find('.vote a');
    buttons.addClass('disabled');
    buttons.off('click');
    // Submit vote
    var post_id = post.attr('data-target');
    $.post('/posts/downvote', {'post_id': post_id}, function(data) {
      // Update count
      el.children('.count').html(data);
    });
  });

  // Comments
  $('.comment-submit').click(function(e) {
    console.log('hi')
  })
})
