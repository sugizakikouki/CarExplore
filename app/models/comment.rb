class Comment < ApplicationRecord
    belongs_to :user
    belongs_to :post
    has_many_attached :images
    has_many :notifications, dependent: :destroy
    
    validates :comment, presence: true, length: {maximum: 150}

end
