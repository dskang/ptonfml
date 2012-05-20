class PostsController < ApplicationController
  # GET /posts
  # GET /posts.json
  def index
    @post = Post.new
    @posts = Post.where(approved: true).paginate(page: params[:page], per_page: 20)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  def review
    @posts = Post.all
    session[:admin_password] = "adminsuperpower"

    respond_to do |format|
      format.html
      format.json { render json: @posts }
    end
  end

  # PUT /posts/1/approve
  def approve
    @post = Post.find(params[:id])
    @post.approved = true
    if @post.save
      redirect_to action: 'review', notice: 'Post was successfully approved.'
    else
      redirect_to action: 'review'
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    if session[:admin_password] == "adminsuperpower"
      @post = Post.find(params[:id])
    else
      redirect_to root_url
    end
  end

  # POST /posts
  def create
    @post = Post.new(params[:post])
    @post.ip = request.remote_ip

    if @post.save
      redirect_to root_url, notice: 'Your post was successfully submitted. It should appear soon.'
    else
      redirect_to root_url
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        # FIXME: Notice does not display for some reason
        format.html { redirect_to action: "review", notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to action: "review" }
      format.json { head :no_content }
    end
  end

  def upvote
    @post = Post.find(params[:post_id])
    @post.likes += 1
    @post.save
    render json: @post.likes
  end

  def downvote
    @post = Post.find(params[:post_id])
    @post.dislikes += 1
    @post.save
    render json: @post.dislikes
  end
end
