class Post < ApplicationRecord
    belongs_to :user
    has_many_attached :images
    has_many :post_comments, dependent: :destroy
end
