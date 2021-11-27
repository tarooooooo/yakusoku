class User < ApplicationRecord
  before_save{self.email = self.email.downcase}
  has_secure_password validations: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  with_options presence: true do
    validates :email, uniqueness: true,
                      length: { maximum: 255 },
                      format: { with: VALID_EMAIL_REGEX }
    validates :nickname, length: { maximum: 50 }
    validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
    validates :introduction, length: { maximum: 800 }
  end
  
  has_many :posts
  has_many :messages, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :rooms, through: :entries
  has_many :tag_relationships, dependent: :destroy
  has_many :tags, through: :tag_relationships
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post
  accepts_nested_attributes_for :tag_relationships, allow_destroy: true
  
  
  def already_liked?(post)
    self.likes.exists?(post_id: post.id)
  end

end