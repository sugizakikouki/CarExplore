class Users::PostsController < ApplicationController
  def index
    @post = Post.new
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])  
  end
  
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    @post.save
    redirect_to request.referer
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
