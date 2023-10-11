module NotificationsHelper
  def notification_form(notification)
    @visitor = notification.visitor
    @comment = nil
    @visitor_comment = notification.comment_id
    case notification.action
    when 'follow'
      tag.a(notification.visitor.name, href: user_path(@visitor)) + 'があなたをフォローしました'
    when 'favorite'
      tag.a(notification.visitor.name, href: user_path(@visitor)) + 'が' + tag.a('あなたの投稿', href: post_path(notification.post_id)) + 'にいいねしました'
    when 'comment'
      @comment = Comment.find_by(id: @visitor_comment)
      if @comment
        @comment_content = @comment.comment
        @micropost_title = @comment.post.content
        tag.a(@visitor.name, href: user_path(@visitor)) + 'が' + tag.a('あなたの投稿', href: post_path(notification.post_id)) + 'にコメントしました'
      end
    end
  end
end
