class CommentsController < ApplicationController
  before_filter :get_parent, only: :create

  # POST /comments
  def create
    @comment = @parent.comments.build(params[:comment])

    # Use default name if none
    if @comment.name.length == 0
      @comment.name = "Anonymous"
    end

    # Make sure only admins can use admin names
    @is_admin = session[:admin]
    if not @is_admin
      if @comment.name == 'The Giant Peach'
        @comment.name = 'Hall of Shame'
      elsif @comment.name == 'A Boy Named James'
        @comment.name = "Hall of Lame"
      end
    end

    # Set IP address
    @comment.ip = request.remote_ip

    if @comment.save
      render partial: 'comment', locals: { comment: @comment }
    else
      render nothing: true
    end
  end

  # DELETE /comments/1
  def destroy
    if session[:admin]
      @comment = Comment.find(params[:id])
      @comment.destroy
    end

    redirect_to root_url
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
