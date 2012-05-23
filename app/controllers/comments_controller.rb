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
    if not is_admin?
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
    @parent = Post.find_by_id(params[:post_id]) unless params[:post_id].blank?
    @parent = Comment.find_by_id(params[:comment_id]) unless params[:comment_id].blank?

    redirect_to root_url if @parent.nil?
  end
end
