class PostType < ApplicationRecord
  has_many :posts, dependent: :nullify
end
