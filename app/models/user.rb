class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts, dependent: :destroy
  mount_uploader :image, ImageUploader
         
  def self.guest
    find_or_create_by!(email: 'guest@guest.com') do |user|
      user.password = SecureRandom.urlsafe_base64
    end
  end
end
