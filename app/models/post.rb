class Post < ApplicationRecord
  belongs_to :user
  belongs_to :post_type
  has_many :comments, dependent: :destroy
  has_many :like_post_relationships, dependent: :destroy
  has_many :user_liked_by, through: :like_post_relationships, source: :user
  has_one_attached :image
  validates :user_id, presence: true
  validates :title, presence: true
  validates :post_type_id, presence: true
  validates :content, presence: true
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
                                    message: '規定のフォーマットにしてください。' },
                    size: { less_than: 5.megabytes,
                            message: '5MB以下にしてください' }
  default_scope -> { order(created_at: :desc) }

  def display_image
    image.variant(resize_to_limit: [300, 300])
  end

  class << self
    def feed
      Post.all
    end
  end
end
