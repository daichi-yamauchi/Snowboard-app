class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :title, presence: true
  validates :content, presence: true
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
                                    message: '規定のフォーマットにしてください。' },
                    size: { less_than: 5.megabytes,
                            message: '5MB以下にしてください' }

  def display_image
    image.variant(resize_to_limit: [300, 300])
  end

  class << self
    def feed
      Post.all
    end
  end
end
