class CommentsController < ApplicationController
  before_filter :get_parent

  def create
    @comment = @parent.comments.build(name: params[:name], body: params[:body])
    if @comment.save
      render json: true
    else
      render json: false
    end
  end

  def get_parent
    @parent = Post.find_by_id(params[:post_id]) if params[:post_id]
    @parent = Comment.find_by_id(params[:comment_id]) if params[:comment_id]

    render json: false unless defined?(@parent)
  end
end
