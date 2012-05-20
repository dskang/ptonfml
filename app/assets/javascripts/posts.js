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
  $('.post-comment').click(function(e) {
    e.preventDefault();
    // Get comment form
    var comment_form = $('.new-comment');
    // Clear form
    comment_form.find('.name-field').val('');
    comment_form.find('.comment-field').val('');
    // Insert comment form after post
    var el = $(this);
    var post = el.closest('.post');
    var comments = post.find('ul.comments');
    comments.append(comment_form);
    comment_form.show();
    // Scroll to comment
    // offset by 60 due to fixed header nav bar
    $('html, body').scrollTop(comment_form.offset().top - 60);
    // Focus on name
    comment_form.find('.name-field').focus();
    // Set post id for comment form
    var input = comment_form.find('input[name="post_id"]');
    var post_id = post.attr('data-target');
    input.attr('value', post_id);
  });

  $('.cancel-comment').click(function(e) {
    var comment_form = $('.new-comment');
    comment_form.hide();
  });

  $('.submit-comment').click(function(e) {
    // Add comment to DOM
    // Clear comment form
  });

  // Infinite scroll
  $('.posts').infinitescroll({
    navSelector: 'div.pagination',
    nextSelector: 'div.pagination a:last',
    itemSelector: '.posts div.post',
    loading: {
      selector: '.load-status'
    }
  });
})
