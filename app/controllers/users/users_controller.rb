class Users::UsersController < ApplicationController
  before_action :set_user
  
  def show
    @user = User.find(params[:id])
    @name = @user.name
    @image = @user.image
    @profile = @user.profile
    @following_users = @user.following_users
    @follower_users = @user.follower_users
    @posts = @user.posts_with_reposts.page(params[:page])
    @post_all = @user.posts
    @post = Post.find(params[:id])
  end

  def edit
    @user = current_user
    @image = @user.image
  end
  
  def update
    if @user.update(user_params)
      flash[:success] = "updated successfully"
      redirect_to user_path(current_user)
    else
      flash.now[:danger] = "Failed to update"
      render :edit
    end
  end
  
  private
  def set_user
      @user = User.find(current_user.id)
  end
  
  def user_params
    params.require(:user).permit(:id, :name, :username, :email, :image, :profile)
  end
  
end
