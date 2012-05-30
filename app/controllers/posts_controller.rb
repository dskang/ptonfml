class PostsController < ApplicationController
  before_filter :set_as_admin, only: :review

  # GET /posts
  # GET /posts.json
  def index
    @post = Post.new
    @posts = Post.approved.recent.paginate(page: params[:page], per_page: 20)

    @votes = session[:votes]

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  def liked
    @post = Post.new
    @posts = Post.approved.most_liked.paginate(page: params[:page], per_page: 20)

    @votes = session[:votes]

    respond_to do |format|
      format.html { render action: 'index' }
      format.json { render json: @posts }
    end
  end

  def disliked
    @post = Post.new
    @posts = Post.approved.most_disliked.paginate(page: params[:page], per_page: 20)

    @votes = session[:votes]

    respond_to do |format|
      format.html { render action: 'index' }
      format.json { render json: @posts }
    end
  end

  def search
    @post = Post.new
    @posts = Post.approved.where("LOWER(content) LIKE ?", '%' + params[:query].downcase + '%').recent.paginate(page: params[:page], per_page: 20)

    @votes = session[:votes]

    respond_to do |format|
      format.html { render action: 'index' }
      format.json { render json: @posts }
    end
  end

  def review
    @posts = Post.unreviewed.recent.paginate(page: params[:page], per_page: 20)

    respond_to do |format|
      format.html
      format.json { render json: @posts }
    end
  end

  # PUT /posts/1/approve
  def approve
    @post = Post.find(params[:id])
    @post.approved = true
    @post.reviewed = true
    if @post.save
      redirect_to action: 'review', notice: 'Post was successfully approved.'
    else
      redirect_to action: 'review'
    end
  end

  # PUT /posts/1/disapprove
  def disapprove
    @post = Post.find(params[:id])
    @post.approved = false
    @post.reviewed = true
    if @post.save
      redirect_to action: 'review', notice: 'Post was successfully disapproved.'
    else
      redirect_to action: 'review'
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])

    @votes = session[:votes]

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    if is_admin?
      @post = Post.find(params[:id])
    else
      redirect_to root_url
    end
  end

  # POST /posts
  def create
    type = params[:post][:type]
    if type == 'FML'
      @post = FML.new(params[:post])
    elsif type == 'Meme'
      @post = Meme.new(params[:post])
    elsif type == 'GIF'
      @post = GIF.new(params[:post])
    end
    @post.ip = request.remote_ip

    if @post.save
      redirect_to root_url, notice: 'Thanks for submitting! Your post should appear soon.'
    else
      @posts = Post.approved.recent.paginate(page: params[:page], per_page: 20)
      render 'index'
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

    # FIXME: Uncomment
    # Check that user has not already voted for this post
    # @votes = session[:votes]
    # if @votes.nil? or not @votes.include? @post.id
      @post.likes += 1
      @post.save

      if session[:votes].nil?
        session[:votes] = Set.new([@post.id])
      else
        session[:votes].add(@post.id)
      end
    # end

    render json: @post.likes
  end

  def downvote
    @post = Post.find(params[:post_id])

    # FIXME: Uncomment
    # Check that user has not already voted for this post
    # @votes = session[:votes]
    # if true or @votes.nil? or not @votes.include? @post.id
      @post.dislikes += 1
      @post.save

      if session[:votes].nil?
        session[:votes] = Set.new([@post.id])
      else
        session[:votes].add(@post.id)
      end
    # end

    render json: @post.dislikes
  end

  private

  def set_as_admin
    session[:admin] = true
  end
end
