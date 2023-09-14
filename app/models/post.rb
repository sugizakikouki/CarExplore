class Post < ApplicationRecord
    belongs_to :user
    has_many_attached :images
    has_many :comments, dependent: :destroy
    has_many :favorites, dependent: :destroy
    has_many :tag_maps, dependent: :destroy
    has_many :tags, through: :tag_maps
    
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
end
