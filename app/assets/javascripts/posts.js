// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

var like_handler = function(e) {
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
}

var dislike_handler = function(e) {
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
}

// Comments
var post_comment_handler = function(e) {
  e.preventDefault();
  var comment_form = $('.new-comment');
  // Clear form
  comment_form.find('.name-field').val('');
  comment_form.find('.comment-field').val('');
  // Insert comment form after post
  var post = $(this).closest('.post');
  var comments = post.find('ul.comments');
  comments.append(comment_form);
  comment_form.show();
  // Scroll to comment
  $('html, body').scrollTop(comment_form.offset().top - 300);
  // Focus on name
  comment_form.find('.name-field').focus();
  // Set post id for comment form
  var post_id = post.attr('data-target');
  var input = comment_form.find('input[name="post_id"]');
  input.attr('value', post_id);
}

var cancel_comment_handler = function(e) {
  e.preventDefault();
  var comment_form = $('.new-comment');
  // Hide form
  comment_form.find('.name-field').val('');
  comment_form.find('.comment-field').val('');
  comment_form.hide();
}

var comment_submit_handler = function(e) {
  e.preventDefault();
  var comments = $(this).closest('.comments');
  $.post('/comments', $(this).serialize(), function(comment_html) {
    var comment = $(comment_html);
    comments.append(comment);
    $('.cancel-comment').click();
  });
}

var unbind_handlers = function() {
  $('a.like').off('click');
  $('a.dislike').off('click');
  $('.post-comment').off('click');
  $('.cancel-comment').off('click');
  $('.comment-form').off('submit');
}

var bind_handlers = function() {
  // Votes
  $('a.like').click(like_handler);
  $('a.dislike').click(dislike_handler);

  // Turn off already voted posts
  $('.disabled').off('click');

  // Comments
  $('.post-comment').click(post_comment_handler);
  $('.cancel-comment').click(cancel_comment_handler);
  $('.comment-form').submit(comment_submit_handler);
}

$(function() {
  // Attach handlers to events
  bind_handlers();

  // Enable alert dismissal
  $('.alert').alert();

  // Infinite scroll
  $('.posts').infinitescroll({
    navSelector: 'div.pagination',
    nextSelector: 'div.pagination a:last',
    itemSelector: '.posts div.post',
    loading: {
      selector: '.load-status'
    }
  }, function() {
    // Unbind handlers and bind them for the new posts
    unbind_handlers();
    bind_handlers();
  });
})
