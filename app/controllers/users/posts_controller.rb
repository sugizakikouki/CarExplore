class Users::PostsController < ApplicationController
  def index
    @post = Post.new
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @comments = Comment.all
  end
  
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    
    tag_list = params[:post][:tag_name].split(nil)
    if @post.save
      @post.save_tag(tag_list)
      flash[:notice] = 'Successfully posted.'
      redirect_to request.referer
    else
      flash[:notice] = 'Posting failed.'
      redirect_to request.referer
    end
  end
  
  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to request.referer
  end
  
  private
  
  def post_params
    params.require(:post).permit(:content, images: [])
  end
end
