class Admins::AdminsController < ApplicationController
    
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
    
    def about
    end
end