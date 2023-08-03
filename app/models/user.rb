class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :profile
  has_many :posts
  has_many :comments

  has_many :follower_relationships, foreign_key: :followed_id, class_name: 'Follow'
  has_many :followers, through: :follower_relationships, source: :follower

  has_many :followed_relationships, foreign_key: :follower_id, class_name: 'Follow'
  has_many :followed_users, through: :followed_relationships, source: :followed

  has_many :saved_posts
  has_many :saved_for_later, through: :saved_posts, source: :post
end
