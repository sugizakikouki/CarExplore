class Users::RelationshipsController < ApplicationController
    def create
        followed_user = User.find(params[:user_id])
        Relationship.create!(follower_id: current_user.id,followed_id: params[:user_id])
        notification = Notification.new(:visitor_id=>current_user.id,:visited_id => followed_user.id,:action=>'follow',:checked =>false)
        notification.save!
        redirect_to request.referer
    end

    def destroy
        Relationship.find_by(follower_id: current_user.id,followed_id: params[:user_id]).destroy
        redirect_to request.referer
    end
end
