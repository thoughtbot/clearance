class PostsController < ApplicationController
  before_filter :ensure_logged_in
  before_filter :load_user
  
  def index
    @posts = @user.posts

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @posts.to_xml }
      format.rss do
        headers['Content-Type'] = 'application/rss+xml'
        session[:special] = '$2 off your next purchase'
        session[:special_user_id] = @user.id
        head :ok
      end
    end
  end

  def show
    @post = @user.posts.find(params[:id])

    respond_to do |format|
      format.html { render :layout => 'wide' }
      format.xml  { render :xml => @post.to_xml }
    end
  end

  def new
    @post = @user.posts.build
    render :layout => false
  end

  def edit
    @post = @user.posts.find(params[:id])
  end

  def create
    @post = @user.posts.build(params[:post])

    respond_to do |format|
      if @post.save
        flash[:notice] = 'Post was successfully created.'
        format.html { redirect_to user_post_url(@post.user, @post) }
        format.xml  { head :created, :location => user_post_url(@post.user, @post) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors.to_xml }
      end
    end
  end

  def update
    @post = @user.posts.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        flash[:notice] = 'Post was successfully updated.'
        format.html { redirect_to user_post_url(@post.user, @post) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors.to_xml }
      end
    end
  end

  def destroy
    @post = @user.posts.find(params[:id])
    @post.destroy
    
    flash[:notice] = "Post was removed"
    
    respond_to do |format|
      format.html { redirect_to user_posts_url(@post.user) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def load_user
    @user = User.find(params[:user_id])
  end
end
