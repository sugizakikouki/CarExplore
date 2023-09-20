class Notification < ApplicationRecord
  default_scope -> { order(created_at: :desc) } #新着順で表示する
  belongs_to :visitor, class_name: "User", optional: true 
  belongs_to :visited, class_name: "User", optional: true
  belongs_to :post, optional: true
end
