class Post < ApplicationRecord
    belongs_to :user
    has_many_attached :images
    has_many :comments, dependent: :destroy
    has_many :favorites, dependent: :destroy
    has_many :tag_maps, dependent: :destroy
    has_many :tags, through: :tag_maps
    has_many :notifications, dependent: :destroy

    
    def favorited_by?(user)
        favorites.exists?(user_id: user.id)
    end
    
    def save_tag(sent_tags)
        current_tags = tags.pluck(:tag_name) unless tags.nil?
        old_tags = current_tags - sent_tags
        new_tags = sent_tags - current_tags
        
        old_tags.each do |old|
            tags.delete Tag.find_by(tag_name: old)
        end
    
        new_tags.each do |new|
            new_post_tag = Tag.find_or_create_by(tag_name: new)
            tags << new_post_tag
        end
    end
    
    def self.search(keyword)
        Post.joins(:user, :tags)
            .where("content LIKE ? or users.username LIKE ? or users.name LIKE ? or tags.tag_name LIKE ?", "%#{sanitize_sql_like(keyword)}%", "%#{sanitize_sql_like(keyword)}%", "%#{sanitize_sql_like(keyword)}%", "%#{sanitize_sql_like(keyword)}%")
    end
    
    def create_notification_favorite(current_user)
        notification = current_user.active_notifications.new(
          comment_id: nil,
          post_id: id,      
          visited_id: user_id,
          action: 'favorite'
          )
        if notification.visitor_id == notification.visited_id
           notification.checked = true
        end
        notification.save if notification.valid?
    end
    
    def create_notification_comment(current_user, comment_id)
        temp_ids = Comment.where(post_id: id).select(:user_id).where.not("user_id = ? or user_id = ?", current_user.id, user_id).distinct 
        temp_ids.each do |temp_id|
            save_notification_comment!(current_user, comment_id, temp_id['user_id'])
        end
        save_notification_comment(current_user, comment_id, user_id)
    end
    
    def save_notification_comment(current_user, comment_id, visited_id)#(通知をした人,通知されたコメント,通知された人)
        notification = current_user.active_notifications.new(
            post_id: id,
            comment_id: comment_id,
            visited_id: visited_id,
            action: 'comment'
        )
        if notification.visitor_id == notification.visited_id
            notification.checked = true
        end
        notification.save if notification.valid?
    end
end
