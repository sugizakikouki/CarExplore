class Users::FavoritesController < ApplicationController
    def create
        @post = Post.find(params[:post_id])
        favorite = current_user.favorites.new(post_id: @post.id)
        favorite.save
        
        notification = Notification.new(:visitor_id=>current_user.id,:visited_id => @post.user_id,:post_id => @post.id,:comment_id=>7,:action=>'favorite',:checked =>false)
        #notification = Notification.new(:visitor_id=>3,:visited_id=>1,:post_id=>30,:comment_id=>7,:action=>'favorite',:checked=>false)
        notification.save!
    end

    def destroy
        @post = Post.find(params[:post_id])
        favorite = current_user.favorites.find_by(post_id: @post.id)
        favorite.destroy
    end
end
