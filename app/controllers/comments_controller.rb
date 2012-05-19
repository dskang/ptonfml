class CommentsController < ApplicationController
  before_filter :get_parent

  def create
    @comment = @parent.comments.build(params[:comment])
    if @comment.save
      redirect_to post_path(@parent) + '#new_comment'
    else
      redirect_to root_url
    end
  end

  def get_parent
    p params
    @parent = Post.find_by_id(params[:post_id]) if params[:post_id]
    # FIXME: Only allow parent to be post for now
    # @parent = Comment.find_by_id(params[:comment_id]) if params[:comment_id]

    # FIXME: if you send an invalid post_id, @parent will be defined!
    # check for nil instead
    redirect_to root_url unless defined?(@parent)
  end
end
