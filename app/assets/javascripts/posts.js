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
var comment_comment_handler = function(e) {
  e.preventDefault();
  var comment = $(this).closest('.comment-container');
  show_comment_form(comment, "comment");
}

var post_comment_handler = function(e) {
  e.preventDefault();
  var post = $(this).closest('.post');
  show_comment_form(post, "post");
}

var show_comment_form = function(parent, type) {
  var comment_form = $('.new-comment');
  // Clear form
  comment_form.find('.name-field').val('');
  comment_form.find('.comment-field').val('');
  // Insert comment form after parent
  var comments = parent.children('ul.comments');
  comments.prepend(comment_form);
  comment_form.show();
  // Scroll to comment
  $('html, body').scrollTop(comment_form.offset().top - 300);
  // Focus on name
  comment_form.find('.name-field').focus();
  // Set parent id for comment form
  var parent_id = parent.attr('data-target');
  var id_input = comment_form.find('input[name="parent_id"]');
  id_input.attr('value', parent_id);
  var type_input = comment_form.find('input[name="parent_type"]');
  type_input.attr('value', type);
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
    comment.find('.comment-comment').click(comment_comment_handler);
    comments.append(comment);
    $('.cancel-comment').click();
    // TODO: Animate scroll to comment and flash background
  });
}

var unbind_handlers = function() {
  $('a.like').off('click');
  $('a.dislike').off('click');
  $('.post-comment').off('click');
  $('.comment-comment').off('click');
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
  $('.comment-comment').click(comment_comment_handler);
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
      selector: '.load-status',
      finishedMsg: "Congratulations, you've reached the end of the internet.",
      msgText: "Loading more posts..."
    }
  }, function() {
    // Unbind handlers and bind them for the new posts
    unbind_handlers();
    bind_handlers();
  });
})
