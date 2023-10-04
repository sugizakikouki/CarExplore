class Admins::AdminsController < ApplicationController
    before_action :authenticate_admin!

    def index
        @users = User.page(params[:page])
    end
    
    def show
        @user = User.find(params[:id])
        @name = @user.name
        @image = @user.image
        @profile = @user.profile
        @following_users = @user.following_users
        @follower_users = @user.follower_users
        @posts = @user.posts_with_reposts.page(params[:page])
    end
    
    def destroy
        User.find(params[:id]).destroy
        flash[:success] = "User deleted"
        redirect_to admins_admins_path
    end
end
