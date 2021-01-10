class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_one_attached :image
  validates :user_id, presence: true
  validates :post_id, presence: true
  validates :content, presence: true
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
                                    message: '規定のフォーマットにしてください。' },
                    size: { less_than: 5.megabytes,
                            message: '5MB以下にしてください' }
  default_scope -> { order(created_at: :desc) }

  # 表示用のリサイズ済み画像を返す
  def display_image
    image.variant(resize_to_limit: [300, 300])
  end
end
