class Users::CommentsController < ApplicationController
    
    def create
        @post = Post.find(params[:post_id])
        comment = @post.comments.new(comment_params)
        comment.post_id = @post.id
        comment.user_id = current_user.id
        comment.save!
        # redirect_to request.referer
    end
    
    def destroy
        Comment.find(params[:id]).destroy
        @post = Post.find(params[:post_id])
        # redirect_to request.referer
    end

    private

    def comment_params
        params.require(:comment).permit(:comment, images: [])
    end

end
