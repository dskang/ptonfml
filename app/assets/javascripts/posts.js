// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function() {
  $('.like').click(function(e) {
    e.preventDefault();
    var el = $(this);
    var post_id = el.attr('data-target');
    $.post('/posts/upvote', {'post_id': post_id}, function(data) {
      // Disable button
      el.addClass('disabled');
      el.off('click');
      // Update count
      el.children('.count').html(data);
    });
  });
  $('.dislike').click(function(e) {
    e.preventDefault();
    var el = $(this);
    var post_id = el.attr('data-target');
    $.post('/posts/downvote', {'post_id': post_id}, function(data) {
      // Disable button
      el.addClass('disabled');
      el.off('click');
      // Update count
      el.children('.count').html(data);
    });
  });
})
