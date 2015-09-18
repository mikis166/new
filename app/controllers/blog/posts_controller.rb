class Blog::PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :update, :create, :destroy]
  before_filter :find_post, only: [:show,:edit,:update,:destroy]
  before_filter :authorization
  before_filter :admin_user?, except: [:show]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
    @user = User.find_by(params[:user_id])
  end

  # GET /posts/i-am-an-aweome-post-man
  def show
    @blog = true
    @comment = Comment.new( :post => @post )
    @tags = @post.tags.split(",").map(&:to_s)
  end

  # GET /posts/new
  def new
    new_post
  end

  # GET /posts/1/edit
  def edit
  end

  def create
    if new_post(post_params).save
      redirect_to blog_posts_url, notice: 'Post was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to blog_post_url(@post), notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to blog_posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def find_post
      @post = Post.find_by_permalink(params[:id])
    end

    def new_post(attrs={})
      @post ||= current_user.posts.new(attrs)
    end

    def post_params
      params.require(:post).permit(:title, :markdown, :published_at, :tags)
    end
end
