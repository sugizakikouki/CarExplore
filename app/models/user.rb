class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  mount_uploader :image, ImageUploader
  has_many :followers, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followeds, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

  has_many :following_users, through: :followers, source: :followed
  has_many :follower_users, through: :followeds, source: :follower
  
  has_many :reposts, class_name: 'Post', foreign_key: 'repost_id'
  
  has_many :active_notifications, class_name: "Notification", foreign_key:"visitor_id", dependent: :destroy
  has_many :passive_notifications, class_name: "Notification", foreign_key:"visited_id", dependent: :destroy

         
  def self.guest
    find_or_create_by!(email: 'guest@guest.com') do |user|
      user.password = SecureRandom.urlsafe_base64
    end
  end
  
  def follow(user_id)
    followers.create(followed_id: user_id)
  end

  def unfollow(user_id)
    followers.find_by(followed_id: user_id).destroy
  end

  def following?(user)
    following_users.include?(user)
  end
  
  def posts_with_reposts
    # ユーザーの投稿とリポストを取得するロジックを追加
    posts = self.posts.limit(10)
    reposts = self.reposts.limit(10)
    
    # 投稿とリポストを合成してソート
    all_posts = (posts + reposts).sort_by(&:created_at).reverse

    return Kaminari.paginate_array(all_posts).page(1).per(10)
  end
  
  
  def create_notification_follow(current_user)
    notification = current_user.active_notifications.new(
      visited_id: id, 
      action: 'follow'
    )
    notification.save if notification.valid?
  end

end
