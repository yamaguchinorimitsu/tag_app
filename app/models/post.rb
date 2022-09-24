class Post < ApplicationRecord
  has_one_attached :image
  validates :text, presence: true
  validates :image, presence: true

  has_many :post_tag_relations
  has_many :tags, through: :post_tag_relations
end
